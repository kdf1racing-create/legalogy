#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${LEGALOGY_IMAGE:-${CLAWDBOT_IMAGE:-legalogy:local}}"
CONFIG_DIR="${LEGALOGY_CONFIG_DIR:-${CLAWDBOT_CONFIG_DIR:-$HOME/.legalogy}}"
WORKSPACE_DIR="${LEGALOGY_WORKSPACE_DIR:-${CLAWDBOT_WORKSPACE_DIR:-$HOME/.legalogy/workspace}}"
PROFILE_FILE="${LEGALOGY_PROFILE_FILE:-${CLAWDBOT_PROFILE_FILE:-$HOME/.profile}}"

PROFILE_MOUNT=()
if [[ -f "$PROFILE_FILE" ]]; then
  PROFILE_MOUNT=(-v "$PROFILE_FILE":/home/node/.profile:ro)
fi

echo "==> Build image: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" -f "$ROOT_DIR/Dockerfile" "$ROOT_DIR"

echo "==> Run live model tests (profile keys)"
docker run --rm -t \
  --entrypoint bash \
  -e COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
  -e HOME=/home/node \
  -e NODE_OPTIONS=--disable-warning=ExperimentalWarning \
  -e LEGALOGY_LIVE_TEST=1 \
  -e LEGALOGY_LIVE_MODELS="${LEGALOGY_LIVE_MODELS:-${CLAWDBOT_LIVE_MODELS:-all}}" \
  -e LEGALOGY_LIVE_PROVIDERS="${LEGALOGY_LIVE_PROVIDERS:-${CLAWDBOT_LIVE_PROVIDERS:-}}" \
  -e LEGALOGY_LIVE_MODEL_TIMEOUT_MS="${LEGALOGY_LIVE_MODEL_TIMEOUT_MS:-${CLAWDBOT_LIVE_MODEL_TIMEOUT_MS:-}}" \
  -e LEGALOGY_LIVE_REQUIRE_PROFILE_KEYS="${LEGALOGY_LIVE_REQUIRE_PROFILE_KEYS:-${CLAWDBOT_LIVE_REQUIRE_PROFILE_KEYS:-}}" \
  -v "$CONFIG_DIR":/home/node/.legalogy \
  -v "$WORKSPACE_DIR":/home/node/.legalogy/workspace \
  "${PROFILE_MOUNT[@]}" \
  "$IMAGE_NAME" \
  -lc "set -euo pipefail; [ -f \"$HOME/.profile\" ] && source \"$HOME/.profile\" || true; cd /app && pnpm test:live"
