#!/bin/bash

echo "Syncing..."
git fetch > /dev/null
git pull > /dev/null

if [ `git status -s -u | grep -c -e "^??\|M\|D"` -gt 0 ]; then
    git add --all . > /dev/null
    echo "message commit"
    read input

    git commit -m "$input" > /dev/null
fi

git push -u origin master > /dev/null
