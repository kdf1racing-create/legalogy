#!/usr/bin/env bash
set -euo pipefail

cd /repo

export LEGALOGY_STATE_DIR="/tmp/legalogy-test"
export LEGALOGY_CONFIG_PATH="${LEGALOGY_STATE_DIR}/legalogy.json"

echo "==> Build"
pnpm build

echo "==> Seed state"
mkdir -p "${LEGALOGY_STATE_DIR}/credentials"
mkdir -p "${LEGALOGY_STATE_DIR}/agents/main/sessions"
echo '{}' >"${LEGALOGY_CONFIG_PATH}"
echo 'creds' >"${LEGALOGY_STATE_DIR}/credentials/marker.txt"
echo 'session' >"${LEGALOGY_STATE_DIR}/agents/main/sessions/sessions.json"

echo "==> Reset (config+creds+sessions)"
pnpm legalogy reset --scope config+creds+sessions --yes --non-interactive

test ! -f "${LEGALOGY_CONFIG_PATH}"
test ! -d "${LEGALOGY_STATE_DIR}/credentials"
test ! -d "${LEGALOGY_STATE_DIR}/agents/main/sessions"

echo "==> Recreate minimal config"
mkdir -p "${LEGALOGY_STATE_DIR}/credentials"
echo '{}' >"${LEGALOGY_CONFIG_PATH}"

echo "==> Uninstall (state only)"
pnpm legalogy uninstall --state --yes --non-interactive

test ! -d "${LEGALOGY_STATE_DIR}"

echo "OK"
