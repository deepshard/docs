#!/usr/bin/env bash
set -euo pipefail

# Keep remote-access credentials out of this public repository. The patterns
# are split so the guard does not flag its own source.
patterns=(
  'truffle://remote/'
  'session''Token='
  'client''UserId='
  'relay[_-]key'
)

status=0
for pattern in "${patterns[@]}"; do
  if git grep -n -E "$pattern" -- ':!scripts/check-public-content.sh'; then
    status=1
  fi
done

if (( status != 0 )); then
  echo 'Remote-access credentials must not be committed to public docs.' >&2
  exit 1
fi

echo 'No Truffle remote-access credentials found.'
