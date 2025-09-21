{
  description = "A flake for my wyfy.dev dev environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    blowfish-tool = {
      url = "github:nunocoracao/blowfish";
      flake = false;
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      # Hugo theme - you can add your theme as a flake input or git submodule
      # Example: using a popular theme
      hugoTheme = pkgs.fetchFromGitHub {
        owner = "adityatelange";
        repo = "hugo-PaperMod";
        rev = "master";
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Replace with actual hash
      };

      # Website configuration
      siteName = "my-website";
      baseURL = "https://example.com";
    in {
      # Development shell with Hugo and useful tools
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          hugo
          go # For Hugo modules if needed
          git
          nodejs # For some themes/tools

          # Optional: deployment tools
          rsync
          netlify-cli

          # Optional: image optimization
          imagemagick
          optipng
          jpegoptim
        ];

        shellHook = ''
          echo "🚀 Hugo development environment"
          echo ""
          echo "Useful commands:"
          echo "  hugo new site ${siteName}  - Create new site"
          echo "  hugo server -D              - Start development server with drafts"
          echo "  hugo new posts/my-post.md   - Create new post"
          echo "  nix build                   - Build production site"
          echo "  nix run .#serve            - Serve production build"
          echo ""

          # Create site if it doesn't exist
          if [ ! -f "config.toml" ] && [ ! -f "hugo.toml" ] && [ ! -f "config.yaml" ]; then
            echo "No Hugo site found. Initialize with: hugo new site . --force"
          fi
        '';
      };

      # Build the static website
      packages = {
        default = self.packages.${system}.website;

        website = pkgs.stdenv.mkDerivation {
          pname = siteName;
          version = "1.0.0";

          src = ./.;

          nativeBuildInputs = with pkgs; [hugo git];

          buildPhase = ''
            # Copy theme if using external theme
            # mkdir -p themes
            # cp -r ${hugoTheme} themes/PaperMod

            # Build site
            hugo --minify --baseURL "${baseURL}"
          '';

          installPhase = ''
            cp -r public $out
          '';
        };

        # Docker image for deployment
        docker = pkgs.dockerTools.buildImage {
          name = siteName;
          tag = "latest";

          copyToRoot = pkgs.buildEnv {
            name = "image-root";
            paths = with pkgs; [
              bashInteractive
              coreutils
              nginx
            ];
            pathsToLink = ["/bin" "/etc/nginx"];
          };

          config = {
            Cmd = ["nginx" "-g" "daemon off;"];
            ExposedPorts = {
              "80/tcp" = {};
            };
            WorkingDir = "/usr/share/nginx/html";
          };

          runAsRoot = ''
            #!${pkgs.runtimeShell}
            mkdir -p /usr/share/nginx/html
            cp -r ${self.packages.${system}.website}/* /usr/share/nginx/html/

            cat > /etc/nginx/nginx.conf << 'EOF'
            events { worker_connections 1024; }
            http {
              include /etc/nginx/mime.types;
              server {
                listen 80;
                root /usr/share/nginx/html;
                index index.html;
                location / {
                  try_files $uri $uri/ /404.html;
                }
              }
            }
            EOF
          '';
        };
      };

      # Useful apps/scripts
      apps = {
        # Serve the built website locally
        serve = {
          type = "app";
          program = "${pkgs.writeShellScript "serve" ''
            echo "Serving website at http://localhost:8080"
            ${pkgs.python3}/bin/python -m http.server 8080 \
              --directory ${self.packages.${system}.website}
          ''}";
        };

        # Deploy via rsync
        deploy = {
          type = "app";
          program = "${pkgs.writeShellScript "deploy" ''
            if [ -z "$DEPLOY_HOST" ] || [ -z "$DEPLOY_PATH" ]; then
              echo "Set DEPLOY_HOST and DEPLOY_PATH environment variables"
              exit 1
            fi

            echo "Deploying to $DEPLOY_HOST:$DEPLOY_PATH"
            ${pkgs.rsync}/bin/rsync -avz --delete \
              ${self.packages.${system}.website}/ \
              "$DEPLOY_HOST:$DEPLOY_PATH"
          ''}";
        };

        # Create new post with timestamp
        new-post = {
          type = "app";
          program = "${pkgs.writeShellScript "new-post" ''
            if [ -z "$1" ]; then
              echo "Usage: nix run .#new-post -- \"Post Title\""
              exit 1
            fi

            POST_TITLE="$1"
            POST_DATE=$(date +%Y-%m-%d)
            POST_SLUG=$(echo "$POST_TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
            POST_FILE="content/posts/$POST_DATE-$POST_SLUG.md"

            ${pkgs.hugo}/bin/hugo new "posts/$POST_DATE-$POST_SLUG.md"
            echo "Created: $POST_FILE"
          ''}";
        };
      };
    });
}
