# Exercise 1: CLI Chat Basics

**Duration:** ~20 minutes  
**Difficulty:** Beginner

In this exercise you will interact with NanoBot through the command line, explore its built-in tools, and understand how it works as an AI agent.

---

## 1.1 — Your First Message

Send a simple message to NanoBot:

```bash
nanobot agent -m "Hello! What can you do?"
```

NanoBot will respond with a description of its capabilities. Notice that it knows it has access to tools like file reading, shell execution, and web search.

---

## 1.2 — Interactive Chat Mode

Start an interactive session:

```bash
nanobot agent
```

You are now in a conversation with NanoBot. Try the following prompts one at a time:

1. **General knowledge:**
   ```
   Explain what a Kubernetes pod is in 3 sentences.
   ```

2. **System awareness:**
   ```
   What operating system am I running? What Python version is installed?
   ```
   > Notice how NanoBot uses its `exec` tool to run shell commands and inspect the system.

3. **File operations:**
   ```
   List the files in /app/exercises/ and give me a summary of what's there.
   ```
   > NanoBot uses its `list_dir` and `read_file` tools to explore the filesystem.

4. **Creating files:**
   ```
   Create a file called ~/hello.py that prints "Hello from NanoBot!" and then run it.
   ```
   > Watch NanoBot use `write_file` to create the file and `exec` to run it.

To exit the interactive session, type `exit`, `quit`, or press `Ctrl+D`.

---

## 1.3 — Exploring NanoBot's Tools

NanoBot has several built-in tools. Ask it about them:

```bash
nanobot agent -m "What tools do you have available? List them with descriptions."
```

The core tools are:

| Tool          | Description                                     |
| ------------- | ----------------------------------------------- |
| `read_file`   | Read contents of a file                         |
| `write_file`  | Write content to a file                         |
| `edit_file`   | Edit a file by replacing specific text           |
| `list_dir`    | List directory contents                          |
| `exec`        | Execute a shell command                          |
| `web_search`  | Search the web (requires Brave Search API key)   |
| `web_fetch`   | Fetch and read a web page                        |
| `send_message`| Send a message on a chat channel                 |

---

## 1.4 — Agent Coding Challenge

Let's see NanoBot write some code. Try this in interactive mode:

```bash
nanobot agent
```

Then give it a task:

```
Create a Python script at ~/workshop/fizzbuzz.py that:
1. Takes a number N as a command line argument
2. Prints FizzBuzz from 1 to N
3. Has proper error handling for invalid input
4. Includes a docstring

Then run it with N=20 and show me the output.
```

Observe how NanoBot:
1. Plans the implementation
2. Writes the file using `write_file`
3. Runs the script using `exec`
4. Shows you the result

---

## 1.5 — Web Fetch

NanoBot can fetch and read web pages. Try:

```
Fetch https://github.com/HKUDS/nanobot and tell me how many stars the project has and who the main contributors are.
```

---

## 1.6 — Multi-step Tasks

Give NanoBot a more complex task that requires multiple tool calls:

```
1. Create a directory ~/workshop/project
2. Inside it, create a simple Flask app (app.py) with a /health endpoint returning JSON
3. Create a requirements.txt with Flask listed
4. Create a Dockerfile for this Flask app
5. Show me the directory structure when done
```

Watch how NanoBot chains multiple tool calls together to complete the entire task.

---

## 1.7 — Memory

NanoBot has persistent memory within a session. Try having a longer conversation:

```
My name is [your name] and I'm attending the NanoBot workshop at Ilionx.
```

Then later in the same session:

```
What's my name and what am I doing today?
```

NanoBot should remember the context from earlier in the conversation.

---

## Recap

In this exercise you learned:

- ✅ How to send messages via CLI (`nanobot agent -m "..."`)
- ✅ How to use interactive chat (`nanobot agent`)
- ✅ How NanoBot uses tools (file I/O, shell, web)
- ✅ How NanoBot can write, run, and debug code
- ✅ How conversation context is maintained within a session

---

**Next:** [Exercise 2 — Telegram Bot](02-telegram-bot.md)
