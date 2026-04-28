#!/usr/bin/env bash

set -euo pipefail

if ! command -v elan >/dev/null 2>&1; then
  curl https://elan.lean-lang.org/elan-init.sh -sSf | sh -s -- -y
fi

# Ensure the current shell can find elan-installed tools on CI providers.
if [ -f "${HOME}/.elan/env" ]; then
  # shellcheck source=/dev/null
  . "${HOME}/.elan/env"
fi

lake exe generate-site --output _site
