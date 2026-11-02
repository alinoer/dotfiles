# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="/usr/local/opt/mysql/bin:$PATH"

export PATH=$PATH:./node_modules/.bin


# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="/Users/aran/Library/Application Support/Herd/config/php/83/"


# Herd injected PHP binary.
export PATH="/Users/aran/Library/Application Support/Herd/bin/":$PATH


# Herd injected PHP 7.4 configuration.
export HERD_PHP_74_INI_SCAN_DIR="/Users/aran/Library/Application Support/Herd/config/php/74/"
export PATH="/usr/local/opt/postgresql@15/bin:$PATH"
export PATH="/usr/local/opt/postgresql@15/bin:$PATH"
export PATH="/aran/local/opt/postgresql@15/bin:$PATH"
export PATH="/usr/local/opt/postgresql@15/bin:$PATH"
export PATH="/usr/local/opt/postgresql@15/bin:$PATH"
export PATH="/usr/local/opt/postgresql@15/bin:$PATH"
export PATH="/usr/local/opt/postgresql@15/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias ls="eza --color=always --long --no-filesize --icons=always --no-time --no-user --no-permissions"

eval "$(zoxide init zsh)"
alias cd="z"

export PATH="/usr/local/opt/postgresql@15/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

. "$HOME/.local/bin/env"

# bun completions
[ -s "/Users/aran/.bun/_bun" ] && source "/Users/aran/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=$PATH:$(go env GOPATH)/bin

alias dev="bun run dev"
alias build="bun run build"
alias start="bun run start"

alias gitfp="git fetch && git pull"


# ============================================================
# PROJECT WORKSPACE MANAGEMENT
# ============================================================

export PATH="$HOME/bin:$PATH"
source ~/.config/shell/project-aliases.sh
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
