#!/usr/bin/env bash
set -euo pipefail

blocked_paths='^(\.dart_tool|build|\.idea)(/|$)|\.iml$'
browser_data='(^|/)(Cookies|History|Login Data|Web Data)(-journal)?$|(^|/)(Local|Session) Storage/'

if git ls-files | grep -E "${blocked_paths}|${browser_data}"; then
  echo "Generated or browser-profile data is tracked. Remove it before committing."
  exit 1
fi

if git grep -n -E 'scanprox\.de|/api/client/[0-9]+' -- lib web; then
  echo "A private production endpoint is referenced in public source."
  exit 1
fi

echo "Repository hygiene checks passed."
