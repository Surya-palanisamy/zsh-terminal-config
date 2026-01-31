
typeset -U PATH path

# ===============================
# BASIC ENVIRONMENT
# ===============================
export ZSH_DISABLE_COMPFIX=true

path=(
  $HOME/.local/bin
  $HOME/.bun/bin
  $HOME/bin
  /usr/local/bin
  $path
)

export PATH
# ===============================
# HISTORY
# ===============================
HISTSIZE=5000
SAVEHIST=5000
HISTFILE="$HOME/.zsh_history"
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# ===============================
# ALIASES
# ===============================
alias ll='ls -lah'
alias gs='git status'
alias update='sudo dnf upgrade --refresh'
alias cls='clear'
alias inv='nvim $(fzf -m --preview=@@HL36@@)'
alias bios='systemctl reboot --firmware-setup'

# ===============================
# COMPLETION
# ===============================
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

setopt AUTO_PARAM_SLASH

# ===============================
# COLORS & PROMPT
# ===============================
autoload -U colors && colors
setopt PROMPT_SUBST

# Capture last exit status
precmd() {
  LAST_EXIT=$?
}

# Git branch
git_branch() {
  local branch
  branch=$(git branch --show-current 2>/dev/null)
  [[ -n "$branch" ]] && echo "%F{green} $branch%f"
}

# Error symbol on failure
exit_status() {
  [[ $LAST_EXIT -ne 0 ]] && echo "%F{red}✘%f"
}

PROMPT='%F{cyan}%n%f@%F{magenta}%m%f %F{yellow}%~%f $(git_branch)
$(exit_status)
$ '

# ===============================
# KEYBINDINGS
# ===============================
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# ===============================
# QUALITY OF LIFE
# ===============================
setopt AUTO_CD
setopt CORRECT
setopt NO_BEEP

# ===============================
# FASTFETCH (Konsole-safe)
# ===============================
if [[ -z "$FASTFETCH_SHOWN" && -o interactive ]]; then
  export FASTFETCH_SHOWN=1
  fastfetch
fi

# Let apps know we are using Konsole
export TERMINAL=konsole

# ===============================
# ZSH AUTOSUGGESTIONS
# ===============================
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ===============================
# ZSH SYNTAX HIGHLIGHTING
# ===============================
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_STYLES[command]='fg=green'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path]='fg=8'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=white'
