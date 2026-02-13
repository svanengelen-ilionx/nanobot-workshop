#!/usr/bin/env bash
# build-and-push.sh — Build the workshop image and push to the container registry
set -euo pipefail

REGISTRY="${REGISTRY:-harbor.openshift-sandbox.ilionx-ocp.com:60443}"
IMAGE_NAME="${IMAGE_NAME:-nanobot/nanobot-workshop}"
TAG="${TAG:-latest}"
FULL_IMAGE="${REGISTRY}/${IMAGE_NAME}:${TAG}"

echo "=== Building NanoBot Workshop Image ==="
echo "Image: ${FULL_IMAGE}"
echo ""

docker build -t "${FULL_IMAGE}" .

echo ""
echo "=== Pushing to Registry ==="
docker push "${FULL_IMAGE}"

echo ""
echo "=== Done ==="
echo "Image available at: ${FULL_IMAGE}"
echo ""
echo "Participants can now create workspaces using this image."
