#!/usr/bin/env bash
set -e

echo "Building site..."
npm run build

echo "Deploying to Codeberg Pages..."
cd build

# Check if git repo exists
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init -b main
    git add .
    git commit -m "Initial deployment" || {
        echo "Nothing to commit"
        cd ..
        exit 1
    }

    # You'll need to set your Codeberg username here
    read -p "Enter your Codeberg username: " USERNAME
    git remote add origin "git@codeberg.org:${USERNAME}/pages.git"

    # Force push first time (in case repo already has content)
    git push -u origin main --force
else
    echo "Updating existing deployment..."
    git add .

    # Only commit if there are changes
    if git diff-index --quiet HEAD --; then
        echo "No changes to deploy"
        cd ..
        exit 0
    fi

    git commit -m "Deploy $(date '+%Y-%m-%d %H:%M:%S')"
    git push
fi

cd ..
echo "✓ Deployment complete!"
echo "Your site will be live at: https://wyfy.codeberg.page"
