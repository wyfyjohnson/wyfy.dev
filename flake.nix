{
  description = "My Hugo Website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      # Website configuration
      siteName = "wyfy-dev";
      baseURL = "https://wyfy.dev";
    in {
      # Development shell with Hugo and useful tools
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          hugo
          git
          nodejs # For some themes/tools

          # Optional: deployment tools
          rsync

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
            # Build site
            hugo --minify --baseURL "${baseURL}"
          '';

          installPhase = ''
            cp -r public $out
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
