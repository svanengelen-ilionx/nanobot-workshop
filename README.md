# NanoBot Workshop

[![Open in Dev Spaces](https://www.eclipse.org/che/contribute.svg)](https://devspaces.apps.openshift-sandbox.ilionx-ocp.com/#https://github.com/svanengelen-ilionx/nanobot-workshop)

Welcome to the **NanoBot AI Assistant Workshop**! In this hands-on session you will set up and interact with [NanoBot](https://github.com/HKUDS/nanobot) — an ultra-lightweight personal AI assistant (~4,000 lines of code).

## What is NanoBot?

NanoBot is an open-source AI agent that can:

- **Chat** interactively via the command line
- **Execute shell commands** and **edit files** on your behalf
- **Search the web** and fetch web pages
- **Connect to chat platforms** like Telegram, Discord, Slack, and more
- **Run on a schedule** with cron-style tasks
- **Learn new skills** via markdown skill files

## Prerequisites

- Access to the OpenShift Dev Spaces environment
- An LLM API key (OpenRouter **or** Azure OpenAI — provided by your facilitator)
- (For Exercise 2) A Telegram account and a bot token

## Getting Started

### 1. Open your Dev Space

Navigate to the Dev Spaces dashboard:

```
https://devspaces.apps.openshift-sandbox.ilionx-ocp.com
```

Click **"Create Workspace"** and enter this repository URL:

```
https://github.com/<your-org>/nanobot-workshop
```

> Your facilitator will provide the exact URL.

Wait for the workspace to start. This may take 1-2 minutes on first launch.

### 2. Open a terminal

Once the workspace is ready, open a terminal:

- **VS Code**: `Terminal` → `New Terminal`
- Or click the **"NanoBot: Show Status"** task in the command palette

### 3. Configure your API key

Copy the config template and add your API key:

```bash
# Copy the template (only if no config exists yet)
cp /app/config-template.json ~/.nanobot/config.json

# Edit the config
nano ~/.nanobot/config.json
```

See the next section for provider-specific configuration.

### 4. Verify the setup

```bash
nanobot status
```

You should see your provider and model listed as configured.

---

## Provider Configuration

Edit `~/.nanobot/config.json` with **one** of the following configurations.

### Option A: OpenRouter (recommended)

OpenRouter gives you access to many models (Claude, GPT, Gemini, etc.) through a single API key.

```json
{
  "providers": {
    "openrouter": {
      "apiKey": "sk-or-v1-YOUR_KEY_HERE"
    }
  },
  "agents": {
    "defaults": {
      "model": "anthropic/claude-sonnet-4"
    }
  }
}
```

> Get a key at [openrouter.ai/keys](https://openrouter.ai/keys)

### Option B: Azure OpenAI

If your organization provides Azure OpenAI access:

```json
{
  "providers": {
    "openai": {
      "apiKey": "YOUR_AZURE_API_KEY",
      "apiBase": "https://YOUR_RESOURCE.openai.azure.com/"
    }
  },
  "agents": {
    "defaults": {
      "model": "azure/YOUR_DEPLOYMENT_NAME"
    }
  }
}
```

> Your facilitator will provide the Azure endpoint and deployment name.

---

## Exercises

Proceed to the exercises in the [exercises/](exercises/) folder:

| #   | Exercise                     | Duration | Difficulty |
| --- | ---------------------------- | -------- | ---------- |
| 1   | [CLI Chat Basics](exercises/01-cli-chat.md)       | 20 min   | Beginner   |
| 2   | [Telegram Bot](exercises/02-telegram-bot.md)      | 25 min   | Intermediate |

---

## Useful Commands

| Command                        | Description                        |
| ------------------------------ | ---------------------------------- |
| `nanobot status`               | Show current configuration status  |
| `nanobot agent`                | Start interactive chat             |
| `nanobot agent -m "message"`   | Send a single message              |
| `nanobot gateway`              | Start the gateway (for Telegram)   |
| `nanobot onboard`              | Re-initialize config & workspace   |

## Troubleshooting

### "No API key configured"

Make sure your `~/.nanobot/config.json` contains a valid API key under the `providers` section.

### Model not responding

- Check the model name matches your provider (e.g. `anthropic/claude-sonnet-4` for OpenRouter, `azure/deployment-name` for Azure)
- Verify your API key has sufficient credits/quota
- Run `nanobot status` to check connectivity

### Gateway won't start

- Ensure port 18790 is not already in use: `lsof -i :18790`
- Check the terminal output for error messages

### Permission denied errors

- The container runs as root, so this should not occur
- If it does, check file ownership: `ls -la ~/.nanobot/`

---

## Resources

- [NanoBot GitHub](https://github.com/HKUDS/nanobot)
- [NanoBot Documentation](https://github.com/HKUDS/nanobot#readme)
- [OpenRouter](https://openrouter.ai/)
- [LiteLLM Docs](https://docs.litellm.ai/) (the library NanoBot uses for LLM calls)
