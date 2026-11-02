#!/usr/bin/env bash
# Setup dotfiles di Mac baru (aman dijalankan berulang kali).
#   git clone git@github.com:alinoer/dotfiles.git ~/dotfiles && ~/dotfiles/install.sh
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(zsh git shell bin nvim tmux ghostty aerospace sketchybar karabiner)

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$1"; }

step "Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

step "Install tool dari Brewfile"
brew bundle --file="$DOTFILES/Brewfile"

step "Cek file yang bentrok sebelum stow"
cd "$DOTFILES"
if ! stow --no --restow "${PACKAGES[@]}" 2>/tmp/stow-check.log; then
  echo "Ada file yang sudah ada dan akan bentrok:"
  grep -E "existing target|cannot stow" /tmp/stow-check.log || cat /tmp/stow-check.log
  echo
  echo "Pindahkan/backup file tersebut dulu, lalu jalankan ulang script ini."
  exit 1
fi

step "Symlink config (stow)"
stow --restow "${PACKAGES[@]}"

step "Plugin tmux (TPM)"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
"$HOME/.tmux/plugins/tpm/bin/install_plugins" || true

step "File secret lokal"
touch "$HOME/.zshrc.local"
chmod 600 "$HOME/.zshrc.local"

step "Selesai"
cat <<'EOF'
Langkah manual:
  - Install nvm & Node:  https://github.com/nvm-sh/nvm
  - Install Bun:         curl -fsSL https://bun.sh/install | bash
  - Buka nvim sekali (plugin ter-install otomatis), lalu :Copilot auth
  - Login GitHub CLI:    gh auth login
  - Simpan token/secret di ~/.zshrc.local (tidak ikut ke git)
EOF
