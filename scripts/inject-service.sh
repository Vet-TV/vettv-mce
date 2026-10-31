#!/usr/bin/env bash
# inject-service.sh - deploy the Layer 2 Python service into a booted
# Batocera VM over SSH and (with --start) launch it. Installs FastAPI +
# uvicorn into /userdata/vettv/pylibs on first run (guest needs network
# for pip). Safe to re-run.
#
# Usage: scripts/inject-service.sh [--help] [--start]
# Env:   VM_HOST (127.0.0.1)  VM_SSH_PORT (2222)  VM_USER (root)  VM_PASS (linux)
set -euo pipefail

START_NOW=0
case "${1:-}" in
    --help|-h) sed -n '2,10p' "$0"; exit 0 ;;
    --start) START_NOW=1 ;;
    "") ;;
    *) echo "Unknown argument: $1 (try --help)" >&2; exit 1 ;;
esac

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="${REPO_ROOT}/service-layer/src/vettv_service"
SERVICE="${REPO_ROOT}/batocera-fork/overlay/userdata/system/services/vettv_service"
VM_HOST="${VM_HOST:-127.0.0.1}"
VM_SSH_PORT="${VM_SSH_PORT:-2222}"
VM_USER="${VM_USER:-root}"
VM_PASS="${VM_PASS:-linux}"

SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p ${VM_SSH_PORT}"
SCP_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -P ${VM_SSH_PORT}"
if command -v sshpass >/dev/null 2>&1; then
    SSH="sshpass -p ${VM_PASS} ssh"
    SCP="sshpass -p ${VM_PASS} scp"
else
    SSH="ssh"
    SCP="scp"
fi
TARGET="${VM_USER}@${VM_HOST}"

# shellcheck disable=SC2086
$SSH $SSH_OPTS "${TARGET}" "mkdir -p /userdata/vettv/service/vettv_service /userdata/vettv/pylibs /userdata/system/services"
# shellcheck disable=SC2086
$SCP $SCP_OPTS "${PKG}"/*.py "${TARGET}:/userdata/vettv/service/vettv_service/"
# shellcheck disable=SC2086
$SCP $SCP_OPTS "${SERVICE}" "${TARGET}:/userdata/system/services/vettv_service"
# shellcheck disable=SC2086
$SSH $SSH_OPTS "${TARGET}" "
    chmod +x /userdata/system/services/vettv_service
    python3 -m ensurepip --default-pip >/dev/null 2>&1 || true
    if [ ! -d /userdata/vettv/pylibs/fastapi ]; then
        python3 -m pip install -q --target /userdata/vettv/pylibs fastapi uvicorn
    fi
    PYTHONPATH=/userdata/vettv/pylibs python3 -c 'import fastapi, uvicorn; print(\"deps ok\", fastapi.__version__)'
    batocera-services enable vettv_service
    grep '^system.services' /userdata/system/batocera.conf
"

if [ "${START_NOW}" -eq 1 ]; then
    # shellcheck disable=SC2086
    $SSH $SSH_OPTS "${TARGET}" "/userdata/system/services/vettv_service restart"
    echo "Service (re)started on 127.0.0.1:8471 inside the guest."
fi

echo "Injected. Service starts automatically on next boot; use --start to launch now."
