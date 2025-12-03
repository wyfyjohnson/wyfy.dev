{
  description = "Wyfy.dev";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # Add Blowfish theme as an input
    blowfish-theme = {
      url = "github:nunocoracao/blowfish";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    blowfish-theme,
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

          postUnpack = ''
            mkdir -p $sourceRoot/themes
            ln -s ${blowfish-theme} $sourceRoot/homethemes/blowfish
          '';

          buildPhase = ''
            # Build site with theme
            hugo --minify --baseURL "${baseURL}"
          '';

          installPhase = ''
            cp -r public $out
          '';
        };
      };

      # Useful apps/scripts
      apps = {
        setup-blowfish = {
          type = "app";
          program = "${pkgs.writeShellScript "setup-blowfish" ''
            echo "Setting up Blowfish theme configuration..."

            # Copy example site config
            cp -r ${blowfish-theme}/exampleSite/config .
            cp -r ${blowfish-theme}/exampleSite/content .
            mkdir -p assets static

            # Copy any assets from example site
            if [ -d "${blowfish-theme}/exampleSite/assets" ]; then
              cp -r ${blowfish-theme}/exampleSite/assets/* assets/ 2>/dev/null || true
            fi

            echo "✓ Copied Blowfish example configuration"
            echo ""
            echo "Next steps:"
            echo "1. Edit config/_default/config.toml with your details"
            echo "2. Edit config/_default/params.toml for theme settings"
            echo "3. Edit config/_default/languages.en.toml for content"
            echo "4. Run: hugo server -D"
          ''}";
        };
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
