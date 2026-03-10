#!/usr/bin/env bash
# setup-config.sh — Interactive setup helper for workshop participants
set -euo pipefail

CONFIG_FILE="${HOME}/.nanobot/config.json"
TEMPLATE_FILE="/app/config-template.json"

echo "╔══════════════════════════════════════════╗"
echo "║     NanoBot Workshop - Config Setup      ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# Auto-configure from OpenShift secret if available
if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
    echo "Detected ANTHROPIC_API_KEY from environment (OpenShift secret)."

    if [ -f "${CONFIG_FILE}" ] && [ "$(cat "${CONFIG_FILE}" 2>/dev/null)" != "{}" ] && [ -s "${CONFIG_FILE}" ]; then
        # Check if the existing config already has the correct key
        EXISTING_KEY=$(jq -r '.providers.anthropic.apiKey // empty' "${CONFIG_FILE}" 2>/dev/null || true)
        if [ "${EXISTING_KEY}" = "${ANTHROPIC_API_KEY}" ]; then
            echo "Config already up to date."
            nanobot status
            exit 0
        fi
    fi

    cat > "${CONFIG_FILE}" <<EOF
{
  "providers": {
    "anthropic": {
      "apiKey": "${ANTHROPIC_API_KEY}",
      "apiBase": "https://ai.krijskraan.nl/anthropic"
    }
  },
  "agents": {
    "defaults": {
      "model": "anthropic/claude-sonnet-4.6"
    }
  }
}
EOF

    echo ""
    echo "Config saved to ${CONFIG_FILE} (using API key from OpenShift secret)"
    echo ""
    echo "Verifying setup..."
    nanobot status
    echo ""
    echo "You're all set! Try: nanobot agent -m \"Hello!\""
    exit 0
fi

# Check if config already exists with content
if [ -f "${CONFIG_FILE}" ] && [ "$(cat "${CONFIG_FILE}" 2>/dev/null)" != "{}" ] && [ -s "${CONFIG_FILE}" ]; then
    echo "A config file already exists at ${CONFIG_FILE}"
    echo ""
    echo "Current config:"
    cat "${CONFIG_FILE}" | jq . 2>/dev/null || cat "${CONFIG_FILE}"
    echo ""
    read -p "Overwrite? (y/N): " OVERWRITE
    if [ "${OVERWRITE}" != "y" ] && [ "${OVERWRITE}" != "Y" ]; then
        echo "Keeping existing config."
        exit 0
    fi
fi

echo ""
read -p "Enter your API key: " API_KEY

cat > "${CONFIG_FILE}" <<EOF
{
  "providers": {
    "anthropic": {
      "apiKey": "${API_KEY}",
      "apiBase": "https://ai.krijskraan.nl/anthropic"
    }
  },
  "agents": {
    "defaults": {
      "model": "anthropic/claude-sonnet-4.6"
    }
  }
}
EOF

echo ""
echo "Config saved to ${CONFIG_FILE}"
echo ""
echo "Verifying setup..."
nanobot status
echo ""
echo "You're all set! Try: nanobot agent -m \"Hello!\""
