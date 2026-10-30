#!/usr/bin/env bash
# build-image.sh - fetch the pinned upstream Batocera image and convert
# it to a VM-ready VDI in build-output/. Phase 1 is an image-level fork:
# no Buildroot rebuild. Apply VetTV changes afterwards with
# scripts/inject-frontend.sh against the booted VM.
#
# Usage: scripts/build-image.sh [--help] [--force]
# Env:   BUILD_OUT   output dir (default: <repo>/build-output)
#        VBOXMANAGE  VBoxManage path (default: auto-detect, incl. WSL .exe)
set -euo pipefail

VERSION="43.1"
FILE="batocera-x86_64-43.1-20260529.img.gz"
URL="https://mirrors.o2switch.fr/batocera/x86_64/stable/last/${FILE}"
SHA256="7ac08d5fcf6f9c00e85e71b6d0c68ddffe710f1e0667aab2931c5bf1509018b8"
DISK_MB=65536

case "${1:-}" in
    --help|-h)
        sed -n '2,12p' "$0"
        exit 0
        ;;
esac
FORCE="${1:-}"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_OUT="${BUILD_OUT:-${REPO_ROOT}/build-output}"
mkdir -p "${BUILD_OUT}"

if [ -z "${VBOXMANAGE:-}" ]; then
    if command -v VBoxManage >/dev/null 2>&1; then
        VBOXMANAGE=VBoxManage
    elif [ -x "/mnt/c/Program Files/Oracle/VirtualBox/VBoxManage.exe" ]; then
        VBOXMANAGE="/mnt/c/Program Files/Oracle/VirtualBox/VBoxManage.exe"
    else
        echo "VBoxManage not found. Install VirtualBox 7 or set VBOXMANAGE." >&2
        exit 1
    fi
fi

cd "${BUILD_OUT}"

if [ ! -f "${FILE}" ] || [ "${FORCE}" = "--force" ]; then
    echo "Downloading ${FILE} ..."
    curl -L --fail -o "${FILE}" "${URL}"
fi

echo "Verifying SHA-256 ..."
echo "${SHA256}  ${FILE}" | sha256sum -c -

IMG="${FILE%.gz}"
if [ ! -f "${IMG}" ] || [ "${FORCE}" = "--force" ]; then
    echo "Decompressing ..."
    gzip -dkf "${FILE}"
fi

if [ ! -f batocera.vdi ] || [ "${FORCE}" = "--force" ]; then
    rm -f batocera.vdi
    echo "Converting to VDI and resizing to ${DISK_MB} MB ..."
    "${VBOXMANAGE}" convertfromraw "${IMG}" batocera.vdi --format VDI
    "${VBOXMANAGE}" modifymedium disk batocera.vdi --resize "${DISK_MB}"
fi

echo "Done: ${BUILD_OUT}/batocera.vdi"
echo "Next: create/boot the VM (scripts/boot-vm.ps1), then run scripts/inject-frontend.sh"
