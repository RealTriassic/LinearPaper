#!/usr/bin/env bash

# file utilized in github actions to automatically update upstream

(
set -e
PS1="$"

# Extract the current paperCommit and mcVersion from the local gradle.properties
currentCommit=$(grep "^paperCommit" gradle.properties | sed "s/paperCommit = //")
currentVersion=$(grep "^mcVersion" gradle.properties | sed "s/mcVersion = //")

# Get the latest paperCommit and mcVersion from the upstream repository
upstreamCommit=$(git ls-remote https://github.com/PaperMC/Paper | grep refs/heads/master | cut -f 1)
upstreamVersion=$(curl -s "https://raw.githubusercontent.com/PaperMC/Paper/$upstreamCommit/gradle.properties" | grep "^mcVersion" | sed "s/mcVersion=//")

# Compare the local and upstream versions
if [ "$currentCommit" != "$upstreamCommit" ] && [ "$currentVersion" == "$upstreamVersion" ]; then
    # Update the local gradle.properties with the latest upstream commit and version
    sed -i 's/paperCommit = .*/paperCommit = '"$upstreamCommit"'/' gradle.properties

    {
      ./gradlew applyPatches --stacktrace && ./gradlew build --stacktrace && ./gradlew rebuildPatches --stacktrace
    } || exit

    git add .
    ./scripts/upstreamCommit.sh $currentCommit $upstreamCommit
fi

) || exit 1
