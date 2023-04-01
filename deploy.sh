#!/bin/sh

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public folder"
# git worktree add -B master public origin/master
# git worktree add --checkout ../public main
git worktree add --track -B gh-pages ./public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo -t "ananke"

# echo "Copy README.md"
# cp README.md public/README.md

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to github personal page branch"

# git push
git push --set-upstream origin gh-pages

echo "Updating builder branch"
cd ../

# Commit and push the changes
git add .
git commit -m "Add GitHub Action workflow"
git push origin builder

# git push