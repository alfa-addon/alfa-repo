#!/bin/bash

set -eu

git config user.name "${GIT_USER_NAME:='Alfa Development Group'}"
git config user.email "${GIT_USER_EMAIL:='145614550+alfa-addon@users.noreply.github.com'}"

BLACKLIST="downloads mediaserver"
EXCLUDES=""

for pattern in $BLACKLIST; do
    export EXCLUDES="$EXCLUDES -not -path \"./$pattern/*\"";
done;

ADDON_ZIPS=$(eval "find . -maxdepth 2 -type f -name '*.zip' $EXCLUDES")

echo "The following zips were found:"
echo $ADDON_ZIPS

echo "Updating repository"
python3 create_repository.py $ADDON_ZIPS
git add .
if git diff --cached --quiet; then
    echo "Repository is already up to date"
    exit 0
fi
git commit -m "Updated addons.xml and md5's"
git push
echo "Update finished!"
