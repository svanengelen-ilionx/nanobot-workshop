# Facilitator Guide

This guide is for the workshop facilitator. It covers how to prepare the environment, build and push the container image, and manage the workshop on the day.

---

## Pre-Workshop Preparation

### 1. Build and Push the Container Image

Make sure you have Docker (or Podman) and access to the Harbor registry.

```bash
# Login to the registry
docker login harbor.openshift-sandbox.ilionx-ocp.com:60443

# Build and push
cd nanobot-workshop/
bash scripts/build-and-push.sh
```

This builds the image and pushes it to:
```
harbor.openshift-sandbox.ilionx-ocp.com:60443/nanobot/nanobot-workshop:latest
```

To use a specific version tag:
```bash
TAG=v1.0 bash scripts/build-and-push.sh
```

### 2. Verify the Image

Test the image locally before the workshop:

```bash
docker run --rm -it \
  harbor.openshift-sandbox.ilionx-ocp.com:60443/nanobot/nanobot-workshop:latest \
  bash -c "nanobot status"
```

### 3. Prepare OpenShift Dev Spaces

1. Ensure the Dev Spaces operator is installed on the OpenShift cluster
2. Verify the image can be pulled from the cluster:
   - The `nanobot` project/namespace in Harbor should be accessible
   - If needed, create an image pull secret in the Dev Spaces namespace
3. Test by creating a workspace yourself using the devfile

### 4. Prepare API Keys

Choose one of:

**Option A (recommended): Pre-provisioned OpenRouter keys**
- Create OpenRouter accounts or use a shared org key
- Set spending limits per key (e.g. $5/participant)
- Prepare a list: participant name → API key

**Option B: Azure OpenAI**
- Ensure the Azure OpenAI resource is deployed
- Note the endpoint URL and deployment name
- Create API keys (can be shared or individual)
- Verify the deployment model and quota is sufficient for 10-20 concurrent users

**Option C: Let participants use their own keys**
- Include key signup instructions in the pre-workshop email

### 5. Pre-Workshop Email / Communication

Send participants:
- [ ] The Dev Spaces URL: `https://devspaces.apps.openshift-sandbox.ilionx-ocp.com`
- [ ] Their OpenShift credentials (or SSO instructions)
- [ ] Their API key (if pre-provisioned)
- [ ] A request to install Telegram on their phone (for Exercise 2)
- [ ] The Git repo URL for the workshop

---

## On the Day

### Agenda (suggested, ~60 min)

| Time     | Activity                                  |
| -------- | ----------------------------------------- |
| 0:00     | Welcome & introduction to NanoBot (5 min) |
| 0:05     | Dev Space setup & config (10 min)         |
| 0:15     | Exercise 1: CLI Chat Basics (20 min)      |
| 0:35     | Exercise 2: Telegram Bot (25 min)         |
| 0:55     | Wrap-up, Q&A (5 min)                      |

### Setup Phase Checklist

- [ ] Confirm all participants can access Dev Spaces
- [ ] Walk through the config setup (run `bash /app/scripts/setup-config.sh`)
- [ ] Have participants run `bash /app/scripts/verify-setup.sh` to confirm
- [ ] Show `nanobot status` on screen so they know what a good result looks like

### Common Issues

| Issue | Solution |
|-------|----------|
| Workspace won't start | Check image pull — may need to add registry credentials as a DevWorkspace secret |
| "No API key configured" | Participant hasn't edited `~/.nanobot/config.json` — walk them through it |
| Slow responses | Model/API may be rate-limited — try a smaller model like `anthropic/claude-sonnet-4` |
| Telegram bot not responding | Check: 1) gateway running? 2) token correct? 3) user ID in `allowFrom`? |
| Out of memory | Increase memory limit in devfile if needed (default: 2Gi) |
| Image pull fails | Ensure Harbor project is public, or create an image pull secret |

### Monitoring

During the workshop, you can check cluster resource usage:

```bash
# See all Dev Spaces workspaces
oc get devworkspaces -A

# Check pod status
oc get pods -n <user-namespace>

# Check pod logs if something goes wrong
oc logs <pod-name> -n <user-namespace>
```

---

## Post-Workshop Cleanup

### Remove Workspaces

Participants can delete their own workspaces from the Dev Spaces dashboard. To bulk-clean:

```bash
# List all dev workspaces
oc get devworkspaces -A

# Delete a specific workspace
oc delete devworkspace <name> -n <namespace>
```

### Revoke API Keys

If you distributed pre-provisioned API keys:
- Revoke/rotate them in OpenRouter or Azure
- Check usage/spending dashboards for anomalies

### Cost Report

Check the API provider dashboards:
- **OpenRouter**: [openrouter.ai/activity](https://openrouter.ai/activity)
- **Azure OpenAI**: Azure Portal → your resource → Metrics

---

## Customization

### Adding More Exercises

Add new `.md` files to the `exercises/` directory and update the README table. Suggested topics:

- **Web search**: Requires a Brave Search API key — add to config under `tools.web.search.api_key`
- **Code generation**: More complex coding tasks
- **Custom skills**: Creating SKILL.md files in `~/.nanobot/workspace/skills/`
- **Scheduled tasks**: Using `nanobot cron` for automation

### Using a Different Model

Change the default model in `config-template.json`. Popular options:

| Provider | Model | Notes |
|----------|-------|-------|
| OpenRouter | `anthropic/claude-sonnet-4` | Good balance of quality and cost |
| OpenRouter | `google/gemini-2.5-flash` | Fast, affordable |
| OpenRouter | `openai/gpt-4o` | GPT-4o |
| Azure | `azure/<deployment>` | Enterprise, data stays in your tenant |

### Restricting Agent Capabilities

For a more controlled workshop, you can restrict NanoBot to its workspace:

```json
{
  "tools": {
    "restrictToWorkspace": true
  }
}
```

This prevents the agent from accessing files or running commands outside `~/.nanobot/workspace/`.
