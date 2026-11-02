# ============================================================
# Powerlevel10k instant prompt — HARUS tetap paling atas.
# Kode yang butuh input (password prompt, [y/n]) taruh di atas blok ini.
# ============================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================
# PATH
# ============================================================
# typeset -U: entri PATH yang dobel otomatis dibuang
typeset -U path PATH

# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="/Users/aran/Library/Application Support/Herd/config/php/83/"

# Herd injected PHP 7.4 configuration.
export HERD_PHP_74_INI_SCAN_DIR="/Users/aran/Library/Application Support/Herd/config/php/74/"

# Herd injected PHP binary.
export PATH="/Users/aran/Library/Application Support/Herd/bin/":$PATH

# Bun
export BUN_INSTALL="$HOME/.bun"

# Go (tanpa memanggil `go env` setiap shell dibuka)
export GOPATH="${GOPATH:-$HOME/go}"

# (N) = lewati kalau folder tidak ada, jadi aman di mesin lain
path=(
  $HOME/bin
  $BUN_INSTALL/bin(N)
  /opt/homebrew/opt/postgresql@15/bin(N)
  /usr/local/opt/mysql/bin(N)
  $path
  $GOPATH/bin(N)
)

# uv / tool Python (~/.local/bin)
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# ============================================================
# Node via nvm (lazy-load supaya shell cepat dibuka)
# Node default langsung ada di PATH (juga untuk Copilot di nvim),
# script nvm baru dimuat saat perintah `nvm` pertama kali dipakai.
# ============================================================
export NVM_DIR="$HOME/.nvm"
() {
  local def nodes
  [[ -r $NVM_DIR/alias/default ]] && def=$(<$NVM_DIR/alias/default) && def=${def#v}
  [[ -n $def && $def != */* ]] && nodes=($NVM_DIR/versions/node/v${def}*(Nn/))
  (( $#nodes )) || nodes=($NVM_DIR/versions/node/v*(Nn/))
  (( $#nodes )) && path=($nodes[-1]/bin $path)
}
nvm() {
  unfunction nvm
  [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"
  nvm "$@"
}

# ============================================================
# Prompt & plugin
# ============================================================
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(zoxide init zsh)"

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# ============================================================
# Alias
# ============================================================
alias ls="eza --color=always --long --no-filesize --icons=always --no-time --no-user --no-permissions"
alias cd="z"

alias dev="bun run dev"
alias build="bun run build"
alias start="bun run start"

alias gitfp="git fetch && git pull"

# Project workspace (pj, pjcd, work)
source ~/.config/shell/project-aliases.sh

# ============================================================
# zsh-syntax-highlighting harus di-source paling akhir dari plugin
# ============================================================
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Secret & setting khusus mesin ini (tidak masuk git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
