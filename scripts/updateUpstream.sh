#!/usr/bin/env bash

set -euo pipefail

# Store current directory
current_dir=$(pwd)

# Temporary directory for upstream repository
temp_dir=$(mktemp -d)

# Ensure the temporary directory is deleted on exit
trap 'rm -rf "$temp_dir"' EXIT

# Clone upstream repository and change directory
git clone --depth 250 --single-branch https://github.com/PaperMC/Paper.git "$temp_dir"
cd "$temp_dir"

# Initialize variables to store upstream commit and attempt counter
attempts=0
upstream_commit=""

# Extract current mcVersion from local gradle.properties
current_version=$(awk -F' = ' '/^mcVersion/ {print $2}' "$current_dir/gradle.properties")

# Iterate over the list of commits until a matching Minecraft version is found
while read -r hash; do
    upstream_version=$(git show "$hash":gradle.properties | awk -F'=' '/^mcVersion/ {print $2}')
    if [ "$upstream_version" = "$current_version" ]; then
        echo "Found $hash for $upstream_version after $attempts loop iterations."
        upstream_commit="$hash"
        break
    fi
    attempts=$((attempts + 1))
done < <(git rev-list HEAD)

# Check if no matching commit was found
if [ -z "$upstream_commit" ]; then
    echo "No matching commit found for $current_version."
    exit 1
fi

# Move back to the original directory
cd "$current_dir"

# Extract current upstream commit from local gradle.properties
current_commit=$(awk -F' = ' '/^paperCommit/ {print $2}' gradle.properties)

# If local and upstream commits differ, update and apply changes
if [ "$current_commit" != "$upstream_commit" ]; then
    echo "Updating commit from $current_commit to $upstream_commit..."
    sed -i 's/paperCommit = .*/paperCommit = '"$upstream_commit"'/' gradle.properties
    ./gradlew applyPatches --stacktrace && ./gradlew rebuildPatches --stacktrace || exit 1

    git add . && ./scripts/upstreamCommit.sh "$current_commit" "$upstream_commit"
    echo "Update complete."
else
    echo "Exiting, current commit is already up-to-date."
fi
