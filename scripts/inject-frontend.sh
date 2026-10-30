#!/usr/bin/env bash
# inject-frontend.sh - deploy the VetTV overlay + Godot Linux export into
# a booted Batocera VM over SSH, enable the vettv_frontend service, and
# (with --start) launch it immediately. Safe to re-run.
#
# Usage: scripts/inject-frontend.sh [--help] [--start]
# Env:   VM_HOST     (default 127.0.0.1)
#        VM_SSH_PORT (default 2222, the VirtualBox NAT forward)
#        VM_USER     (default root)   VM_PASS (default linux, via sshpass if set)
# Requires: ssh, scp; a prior Linux export in frontend/export/linux/
# (godot --headless --path frontend --export-release Linux <abs path>).
set -euo pipefail

START_NOW=0
case "${1:-}" in
    --help|-h) sed -n '2,14p' "$0"; exit 0 ;;
    --start) START_NOW=1 ;;
    "") ;;
    *) echo "Unknown argument: $1 (try --help)" >&2; exit 1 ;;
esac

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EXPORT_DIR="${REPO_ROOT}/frontend/export/linux"
OVERLAY="${REPO_ROOT}/batocera-fork/overlay"
VM_HOST="${VM_HOST:-127.0.0.1}"
VM_SSH_PORT="${VM_SSH_PORT:-2222}"
VM_USER="${VM_USER:-root}"
VM_PASS="${VM_PASS:-linux}"

for f in "${EXPORT_DIR}/VetTV-MCE.x86_64" "${EXPORT_DIR}/VetTV-MCE.pck" \
         "${OVERLAY}/userdata/system/services/vettv_frontend" \
         "${OVERLAY}/userdata/splash/vettv-mce.png"; do
    [ -f "$f" ] || { echo "Missing: $f" >&2; exit 1; }
done

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
$SSH $SSH_OPTS "${TARGET}" "mkdir -p /userdata/vettv/frontend /userdata/system/services /userdata/splash"
# shellcheck disable=SC2086
$SCP $SCP_OPTS "${EXPORT_DIR}/VetTV-MCE.x86_64" "${EXPORT_DIR}/VetTV-MCE.pck" "${TARGET}:/userdata/vettv/frontend/"
# shellcheck disable=SC2086
$SCP $SCP_OPTS "${OVERLAY}/userdata/system/services/vettv_frontend" "${TARGET}:/userdata/system/services/vettv_frontend"
# shellcheck disable=SC2086
$SCP $SCP_OPTS "${OVERLAY}/userdata/splash/vettv-mce.png" "${TARGET}:/userdata/splash/vettv-mce.png"
# shellcheck disable=SC2086
$SSH $SSH_OPTS "${TARGET}" "
    chmod +x /userdata/vettv/frontend/VetTV-MCE.x86_64 /userdata/system/services/vettv_frontend
    batocera-services enable vettv_frontend
    batocera-settings-set system.hostname VETTV-MCE || sed -i 's/^system.hostname=.*/system.hostname=VETTV-MCE/' /userdata/system/batocera.conf
    grep -E '^system\.(services|hostname)' /userdata/system/batocera.conf
"

if [ "${START_NOW}" -eq 1 ]; then
    # shellcheck disable=SC2086
    $SSH $SSH_OPTS "${TARGET}" "/userdata/system/services/vettv_frontend restart"
    echo "Frontend (re)started."
fi

echo "Injected. Service starts automatically on next boot; use --start to launch now."
