#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="ouroboros-html:latest"

echo "=== Building Docker image ${IMAGE_NAME} ==="
docker build -t "${IMAGE_NAME}" -f Dockerfile .

echo "=== Running pipeline stages 0-4 inside Docker ==="
docker run --rm -v "$(pwd):/workspace" -w /workspace "${IMAGE_NAME}" make stages-0-4
