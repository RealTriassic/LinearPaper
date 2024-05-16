#!/usr/bin/env bash

# file utilized in github actions to automatically update upstream

(
set -e
PS1="$"

current=$(cat gradle.properties | grep paperCommit | sed 's/paperCommit = //')
upstream=$(git ls-remote https://github.com/PaperMC/Paper | grep master | cut -f 1)

if [ "$current" != "$upstream" ]; then
    sed -i 's/paperCommit = .*/paperCommit = '"$upstream"'/' gradle.properties
    {
      ./gradlew applyPatches --stacktrace && ./gradlew build --stacktrace && ./gradlew rebuildPatches --stacktrace
    } || exit

    git add .
    ./scripts/upstreamCommit.sh "$current"
fi

) || exit 1
