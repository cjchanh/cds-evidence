#!/usr/bin/env bash
# Rebuild SHA256SUMS from the three exhibit files in this repo.
# Does not regenerate cockpit numbers — those are a point-in-time snapshot.
set -euo pipefail
cd "$(dirname "$0")/.."
{
  shasum -a 256 EVIDENCE-BUNDLE.md
  shasum -a 256 COCKPIT-SNAPSHOT.md
  shasum -a 256 README.md
} > SHA256SUMS
echo "Wrote SHA256SUMS"
shasum -a 256 -c SHA256SUMS
