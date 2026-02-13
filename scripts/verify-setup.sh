#!/usr/bin/env bash
# verify-setup.sh — Quick verification that everything is working
set -euo pipefail

echo "=== NanoBot Workshop - Setup Verification ==="
echo ""

PASS=true

check() {
    local label="$1"
    local cmd="$2"
    if eval "$cmd" > /dev/null 2>&1; then
        echo "  ✅ ${label}"
    else
        echo "  ❌ ${label}"
        PASS=false
    fi
}

echo "Checking tools..."
check "Python 3.12+"         "python3 --version"
check "nanobot CLI"          "which nanobot"
check "Node.js"              "which node"
check "git"                  "which git"
check "jq"                   "which jq"

echo ""
echo "Checking nanobot..."
check "Config file exists"   "[ -f ~/.nanobot/config.json ]"
check "Config is not empty"  "[ -s ~/.nanobot/config.json ] && [ \"\$(cat ~/.nanobot/config.json)\" != '{}' ]"

echo ""
echo "NanoBot status:"
nanobot status 2>&1 || true

echo ""
if $PASS; then
    echo "=== All checks passed! ==="
else
    echo "=== Some checks FAILED — see above ==="
    echo "Run: bash /app/scripts/setup-config.sh"
fi
