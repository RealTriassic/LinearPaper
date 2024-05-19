#!/usr/bin/env bash

# Requires curl & jq

# upstreamCommit <baseHash>
# param: bashHash - the commit hash to use for comparing commits (baseHash...HEAD)

set -euo pipefail

paper=$(curl -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/PaperMC/Paper/compare/$1...$2" | jq -r '.commits[] | "PaperMC/Paper@\(.sha[:7]) \(.commit.message | split("\r\n")[0] | split("\n")[0])"')

updated=""
logsuffix=""
if [ -n "$paper" ]; then
    logsuffix="$logsuffix\n\nPaper Changes:\n$paper"
    updated="Paper"
fi

disclaimer="Upstream has released updates that appear to apply and compile correctly"

log="Updated Upstream ($updated)\n\n${disclaimer}${logsuffix}"

echo -e "$log" | git commit -F -
