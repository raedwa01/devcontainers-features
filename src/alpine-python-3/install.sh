#!/usr/bin/env bash
INSTALL_PYTHON_TOOL="${INSTALLTOOLS:-"true"}"
set -e

echo "Activating feature 'python-3'"


echo "Step 1, check if user is root"
if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

echo "Step 2, determine appropriate non-root user"
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u "${CURRENT_USER}" >/dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} >/dev/null 2>&1; then
    USERNAME=root
fi

echo "Step 3, define helper functions"
apk_get_update()
{
      echo "Running apt-get update..."
      apk update
}

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apk_get_update
        apk add --force --no-cache "$@"
    fi
}

echo "Step 4, check if architecture is supported"
architecture="$(uname -m)"
if [ "${architecture}" != "amd64" ] && [ "${architecture}" != "x86_64" ] && [ "${architecture}" != "arm64" ] && [ "${architecture}" != "aarch64" ]; then
    echo "(!) Architecture $architecture unsupported"
    exit 1
fi

echo "Step 5, install packages"
check_packages python3 py3-pip 

echo "Step 6, install python tools"
if [[ "${INSTALL_PYTHON_TOOLS}" = "true" ]]; then
    echo 'Installing Python tools...'
    apk add --force --no-cache python3-dev
fi

echo "Done!"