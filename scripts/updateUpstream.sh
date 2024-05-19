#!/usr/bin/env bash

set -euo pipefail

# Store current directory
current_dir=$(pwd)

# Temporary directory for upstream repository
temp_dir=$(mktemp -d)

# Extract current paperCommit and mcVersion from gradle.properties
currentCommit=$(awk -F' = ' '/^paperCommit/ {print $2}' gradle.properties)
currentVersion=$(awk -F' = ' '/^mcVersion/ {print $2}' gradle.properties)

# Clone upstream repository and change directory
git clone --depth 250 --single-branch https://github.com/PaperMC/Paper.git "$temp_dir"
cd "$temp_dir"

# Initialize variables to store upstream commit and attempt counter
attempts=0
upstreamCommit=""

# Iterate over the list of commits until a matching Minecraft version is found
while read -r hash; do
    upstreamVersion=$(git show "$hash":gradle.properties | awk -F'=' '/^mcVersion/ {print $2}')
    if [ "$upstreamVersion" = "$currentVersion" ]; then
        echo "Found $hash for $upstreamVersion after $attempts loop iterations."
        upstreamCommit="$hash"
        break
    fi
    attempts=$((attempts + 1))
done < <(git rev-list HEAD)

# Check if no matching commit was found
if [ -z "$upstreamCommit" ]; then
    echo "No matching commit found for $currentVersion."
    rm -rf "$temp_dir"
    exit 1
fi

# Move back to the original directory and remove the temporary directory
cd "$current_dir" || exit
rm -rf "$temp_dir"

# If local and upstream commits differ, update and apply changes
if [ "$currentCommit" != "$upstreamCommit" ]; then
    sed -i 's/paperCommit = .*/paperCommit = '"$upstreamCommit"'/' gradle.properties \
    && git add . && ./scripts/upstreamCommit.sh "$currentCommit" "$upstreamCommit"
else
    echo "Exiting, current commit is already up-to-date."
fi
