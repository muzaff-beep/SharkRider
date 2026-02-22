#!/usr/bin/env bash
# setup.sh — One-time environment configuration / provisioning script
# Usage:   bash setup.sh          (or ./setup.sh after chmod +x)
#          sudo bash setup.sh     (if you need root-level packages)

set -euo pipefail          # Strict mode: fail fast on errors/unset vars
IFS=$'\n\t'                # Safer string splitting

# ──────────────────────────────────────────────────────────────────────────────
#  Config section — change these to match your needs
# ──────────────────────────────────────────────────────────────────────────────

readonly USER_TO_CONFIGURE="${SUDO_USER:-$USER}"
readonly INSTALL_PKGS="curl wget git jq unzip tree htop neovim tmux fzf ripgrep bat zoxide"
readonly WANTED_TOOLS="docker docker-compose nodejs npm python3 python3-pip python3-venv"
readonly DOTFILES_REPO="https://github.com/yourusername/dotfiles.git"   # ← change this
readonly TIMEZONE="Europe/Paris"                                        # ← change this

# Colors for nicer output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

log()  { echo -e "\( {GREEN}[setup] \){NC} $*" >&2; }
warn() { echo -e "\( {YELLOW}[WARN] \){NC} $*" >&2; }
err()  { echo -e "\( {RED}[ERROR] \){NC} $*" >&2; exit 1; }

# ──────────────────────────────────────────────────────────────────────────────
#  Helper functions
# ──────────────────────────────────────────────────────────────────────────────

is_command() {
    command -v "$1" >/dev/null 2>&1
}

ensure_sudo() {
    if [[ $EUID -ne 0 ]]; then
        warn "This step needs root — re-running with sudo..."
        exec sudo bash "$0" "$@"
    fi
}

update_and_install() {
    log "Updating package index + installing base tools..."
    apt-get update -qq
    apt-get install -y --no-install-recommends software-properties-common ca-certificates apt-transport-https
    apt-get upgrade -y --no-install-recommends
    apt-get install -y --no-install-recommends "$@"
}

set_timezone() {
    if [[ -n ${TIMEZONE:-} ]]; then
        log "Setting timezone → $TIMEZONE"
        ln -fs "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
        dpkg-reconfigure -f noninteractive tzdata
    fi
}

install_docker() {
    if ! is_command docker; then
        log "Installing Docker + docker-compose plugin..."
        curl -fsSL https://get.docker.com | sh
        usermod -aG docker "$USER_TO_CONFIGURE"
        # Modern compose is docker compose (plugin), not separate binary
    fi
}

install_node_via_nvm() {
    if ! is_command nvm && ! is_command node; then
        log "Installing NVM + latest LTS Node.js..."
        su - "$USER_TO_CONFIGURE" -c '
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            nvm install --lts
            nvm use --lts
            nvm alias default lts/*
            corepack enable
        '
    fi
}

clone_dotfiles() {
    local dotdir="$HOME/.dotfiles"
    if [[ -n ${DOTFILES_REPO:-} && ! -d "$dotdir" ]]; then
        log "Cloning dotfiles → $DOTFILES_REPO"
        git clone "$DOTFILES_REPO" "$dotdir"
        # Many people symlink or run an install script inside dotfiles
        if [[ -x "$dotdir/install.sh" ]]; then
            "$dotdir/install.sh"
        else
            warn "No install.sh found in dotfiles — symlink manually if needed"
        fi
    fi
}

# ──────────────────────────────────────────────────────────────────────────────
#  Main
# ──────────────────────────────────────────────────────────────────────────────

log "Starting setup for user: $USER_TO_CONFIGURE"

# 1. System basics (needs root)
ensure_sudo
set_timezone
update_and_install $INSTALL_PKGS

# 2. Bigger tools
install_docker
# install_node_via_nvm     # uncomment if you want Node via nvm

# 3. User-level stuff (no sudo needed after this point)
log "Running user-level configuration..."
su - "$USER_TO_CONFIGURE" -c "
    mkdir -p \~/.local/bin
    # Example: install modern replacements if you like them
    if ! is_command bat; then
        ln -sf /usr/bin/batcat \~/.local/bin/bat 2>/dev/null || true
    fi
"

clone_dotfiles

log "Done! 🎉"
log "You may want to log out & log back in (especially for group changes like docker)."
log "Happy hacking!"

exit 0