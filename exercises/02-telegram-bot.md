# Exercise 2: Telegram Bot

**Duration:** ~25 minutes  
**Difficulty:** Intermediate

In this exercise you will connect NanoBot to Telegram, turning it into a personal chat bot you can talk to from your phone.

---

## 2.1 — Create a Telegram Bot

1. Open Telegram on your phone or desktop
2. Search for **@BotFather** and start a conversation
3. Send `/newbot`
4. Follow the prompts:
   - Choose a **name** for your bot (e.g. `My Workshop Bot`)
   - Choose a **username** (must end in `bot`, e.g. `myworkshop_nanobot`)
5. BotFather will give you an **API token** — copy it! It looks like:
   ```
   7123456789:AAF1xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```

---

## 2.2 — Get Your Telegram User ID

You need your user ID to restrict the bot so only you can talk to it.

1. Search for **@userinfobot** in Telegram
2. Start a conversation — it will reply with your user info
3. Copy your **numeric user ID** (e.g. `123456789`)

---

## 2.3 — Configure NanoBot for Telegram

Edit your NanoBot config to add the Telegram channel:

```bash
nano ~/.nanobot/config.json
```

Update the file to include the `channels` section:

### If using OpenRouter:

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
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "YOUR_TELEGRAM_BOT_TOKEN",
      "allowFrom": ["YOUR_TELEGRAM_USER_ID"]
    }
  }
}
```

### If using Azure OpenAI:

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
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "YOUR_TELEGRAM_BOT_TOKEN",
      "allowFrom": ["YOUR_TELEGRAM_USER_ID"]
    }
  }
}
```

**Important:** Replace the placeholder values:
- `YOUR_TELEGRAM_BOT_TOKEN` → the token from BotFather
- `YOUR_TELEGRAM_USER_ID` → your numeric user ID (as a string!)

---

## 2.4 — Start the Gateway

The gateway connects NanoBot to external chat channels:

```bash
nanobot gateway
```

You should see output like:

```
🐈 nanobot gateway starting...
  Telegram: connected
```

> Keep this terminal running! Open a new terminal if you need to run other commands.

---

## 2.5 — Chat with Your Bot

1. Open Telegram
2. Find your bot (search for the username you chose, e.g. `@myworkshop_nanobot`)
3. Send a message: **"Hello!"**

Your bot should respond! It has all the same capabilities as the CLI agent — file operations, shell commands, web fetching, and more.

---

## 2.6 — Try These Conversations

Send these messages to your bot one at a time:

1. **Simple question:**
   ```
   What's the weather like? Search the web for the current weather in the Netherlands.
   ```

2. **System info (the bot runs on your Dev Space!):**
   ```
   What files are in your workspace directory?
   ```

3. **Code generation:**
   ```
   Write a Python one-liner that calculates the first 10 Fibonacci numbers and run it.
   ```

4. **Web awareness:**
   ```
   Fetch https://news.ycombinator.com and tell me the top 3 stories right now.
   ```

---

## 2.7 — Security: The allowFrom Filter

The `allowFrom` list restricts who can talk to your bot. Let's test it:

1. Ask a colleague to send a message to your bot
2. Check the gateway terminal — you should see a message like:
   ```
   Unauthorized user attempted to access bot: <their-user-id>
   ```
3. Their messages will be ignored

**Without `allowFrom`**, anyone who finds your bot could use it (and your API credits!). Always configure it for production use.

---

## 2.8 — Stopping the Gateway

To stop the gateway:
- Press `Ctrl+C` in the terminal running `nanobot gateway`

The bot will go offline in Telegram.

---

## Recap

In this exercise you learned:

- ✅ How to create a Telegram bot via BotFather
- ✅ How to configure NanoBot's Telegram channel
- ✅ How to run the NanoBot gateway
- ✅ How to interact with NanoBot via Telegram
- ✅ How `allowFrom` provides security by restricting access

---

## Bonus: Explore More

If you have time, try these additional activities:

### Change the Model

Stop the gateway, edit your config to use a different model, and restart:

```json
{
  "agents": {
    "defaults": {
      "model": "google/gemini-2.5-flash"
    }
  }
}
```

Then restart: `nanobot gateway`

### Scheduled Messages

Set up a scheduled task via the CLI:

```bash
nanobot cron add --name "reminder" --message "Time to take a break!" --every 1800
```

This sends a message every 30 minutes. List or remove jobs with:

```bash
nanobot cron list
nanobot cron remove <job_id>
```

---

**End of exercises — well done! 🎉**
