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

**Option A (recommended): OpenShift Secret (shared key, zero participant setup)**

Create a Kubernetes secret in each participant's Dev Spaces namespace so the API key is injected automatically. Participants won't need to edit any config — it's populated on workspace start.

```bash
# For a single namespace:
oc create secret generic nanobot-api-key \
  --from-literal=ANTHROPIC_API_KEY='YOUR_API_KEY_HERE' \
  -n <user-devspaces-namespace>

# Label it so Dev Spaces auto-injects it as an env var in every workspace container:
oc label secret nanobot-api-key \
  controller.devfile.io/devworkspace_env=true \
  controller.devfile.io/watch-secret=true \
  -n <user-devspaces-namespace>
```

To create the secret across all participant namespaces at once:

```bash
API_KEY="YOUR_API_KEY_HERE"
for ns in $(oc get namespaces -l app.kubernetes.io/part-of=che.eclipse.org -o jsonpath='{.items[*].metadata.name}'); do
  oc create secret generic nanobot-api-key \
    --from-literal=ANTHROPIC_API_KEY="${API_KEY}" \
    -n "${ns}" 2>/dev/null || echo "Secret already exists in ${ns}"
  oc label secret nanobot-api-key \
    controller.devfile.io/devworkspace_env=true \
    controller.devfile.io/watch-secret=true \
    -n "${ns}" 2>/dev/null || true
done
```

> **Note:** The `controller.devfile.io/devworkspace_env` label tells Dev Spaces to inject each key in the secret as an environment variable. The key name (`ANTHROPIC_API_KEY`) becomes the env var name directly. If the secret doesn't exist, the workspace starts normally and participants can fall back to manual config.

**Option B: Let participants use their own keys**
- Distribute individual API keys to participants
- Participants run `bash /app/scripts/setup-config.sh` and enter their key manually

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
- Revoke/rotate them via the `ai.krijskraan.nl` admin interface
- Check usage/spending dashboards for anomalies

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
| Anthropic (via ai.krijskraan.nl) | `anthropic/claude-sonnet-4` | Default — good balance of quality and cost |
| Anthropic (via ai.krijskraan.nl) | `anthropic/claude-haiku-3-5` | Fast, lightweight |

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
