{
  description = "Wyfy.dev - SvelteKit Portfolio & Blog";

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
      # Allow unfree packages (needed for WebStorm)
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Website configuration
      siteName = "wyfy-dev";
      baseURL = "https://wyfy.dev";
    in {
      # Development shell with SvelteKit and useful tools
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nodejs_22
          nodePackages.npm
          git

          # IDE
          jetbrains.webstorm

          # Optional: deployment tools
          rsync

          # Optional: image optimization
          imagemagick
          optipng
          jpegoptim
        ];

        shellHook = ''
          echo "🚀 SvelteKit development environment"
          echo ""
          echo "Useful commands:"
          echo "  npm install          - Install dependencies"
          echo "  npm run dev          - Start development server"
          echo "  npm run build        - Build production site"
          echo "  npm run preview      - Preview production build"
          echo "  nix run .#new-post   - Create new blog post"
          echo "  webstorm .           - Open project in WebStorm IDE"
          echo ""

          # Check if node_modules exists
          if [ ! -d "node_modules" ]; then
            echo "📦 Dependencies not installed. Run: npm install"
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

          nativeBuildInputs = with pkgs; [
            nodejs_22
            nodePackages.npm
          ];

          buildPhase = ''
            # Set npm cache directory
            export npm_config_cache=$TMPDIR/npm-cache
            export HOME=$TMPDIR

            # Install dependencies
            npm ci --prefer-offline --no-audit

            # Build site
            npm run build
          '';

          installPhase = ''
            cp -r build $out
          '';
        };
      };

      # Useful apps/scripts
      apps = {
        # Serve the built website locally
        serve = {
          type = "app";
          program = "${pkgs.writeShellScript "serve" ''
            echo "Serving production build at http://localhost:4173"
            cd ${self.packages.${system}.website}
            ${pkgs.nodejs_22}/bin/npx vite preview --port 4173
          ''}";
        };

        # Create new blog post with timestamp
        new-post = {
          type = "app";
          program = "${pkgs.writeShellScript "new-post" ''
            if [ -z "$1" ]; then
              echo "Usage: nix run .#new-post -- \"Post Title\""
              exit 1
            fi

            POST_TITLE="$1"
            POST_DATE=$(date +%Y-%m-%d)
            POST_SLUG=$(echo "$POST_TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')
            POST_FILE="src/posts/$POST_DATE-$POST_SLUG.md"

            # Create the post file with frontmatter
            cat > "$POST_FILE" <<EOF
---
title: $POST_TITLE
description: Add a brief description here
date: '$POST_DATE'
categories:
  - blog
published: false
---

Write your content here...
EOF

            echo "✓ Created: $POST_FILE"
            echo ""
            echo "Next steps:"
            echo "1. Edit the post content and metadata"
            echo "2. Set published: true when ready"
            echo "3. Run: npm run dev"
          ''}";
        };
      };
    });
}
