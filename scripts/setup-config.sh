#!/usr/bin/env bash
# setup-config.sh — Interactive setup helper for workshop participants
set -euo pipefail

CONFIG_FILE="${HOME}/.nanobot/config.json"
TEMPLATE_FILE="/app/config-template.json"

echo "╔══════════════════════════════════════════╗"
echo "║     NanoBot Workshop - Config Setup      ║"
echo "╚══════════════════════════════════════════╝"
echo ""

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
echo "Choose your LLM provider:"
echo "  1) OpenRouter (recommended - access to many models)"
echo "  2) Azure OpenAI"
echo ""
read -p "Enter choice (1 or 2): " PROVIDER

case "${PROVIDER}" in
    1)
        read -p "Enter your OpenRouter API key (sk-or-v1-...): " API_KEY
        read -p "Model to use [anthropic/claude-sonnet-4]: " MODEL
        MODEL="${MODEL:-anthropic/claude-sonnet-4}"

        cat > "${CONFIG_FILE}" <<EOF
{
  "providers": {
    "openrouter": {
      "apiKey": "${API_KEY}"
    }
  },
  "agents": {
    "defaults": {
      "model": "${MODEL}"
    }
  }
}
EOF
        ;;
    2)
        read -p "Enter your Azure OpenAI API key: " API_KEY
        read -p "Enter your Azure endpoint (https://xxx.openai.azure.com/): " API_BASE
        read -p "Enter your deployment name: " DEPLOYMENT
        MODEL="azure/${DEPLOYMENT}"

        cat > "${CONFIG_FILE}" <<EOF
{
  "providers": {
    "openai": {
      "apiKey": "${API_KEY}",
      "apiBase": "${API_BASE}"
    }
  },
  "agents": {
    "defaults": {
      "model": "${MODEL}"
    }
  }
}
EOF
        ;;
    *)
        echo "Invalid choice. Please run the script again."
        exit 1
        ;;
esac

echo ""
echo "Config saved to ${CONFIG_FILE}"
echo ""
echo "Verifying setup..."
nanobot status
echo ""
echo "You're all set! Try: nanobot agent -m \"Hello!\""
