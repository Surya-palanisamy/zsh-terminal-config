# BASIC ENVIRONMENT
export ZSH_DISABLE_COMPFIX=true
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# HISTORY
HISTSIZE=5000
SAVEHIST=5000
HISTFILE="$HOME/.zsh_history"
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY

# ALIASES
alias ll='ls -lah'
alias gs='git status'
alias update='sudo dnf upgrade --refresh'
alias cls='clear'

# COMPLETION
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Auto-add trailing slash for directories
setopt AUTO_PARAM_SLASH

# COLORS & PROMPT OPTIONS
autoload -U colors && colors
setopt PROMPT_SUBST


# CAPTURE LAST EXIT STATUS

precmd() {
  LAST_EXIT=$?
}

# Git branch (only inside git repo)
git_branch() {
  local branch
  branch=$(git branch --show-current 2>/dev/null)
  [[ -n "$branch" ]] && echo "%F{green} $branch%f"
}

# Show error symbol only if last command failed
exit_status() {
  [[ $LAST_EXIT -ne 0 ]] && echo "%F{red}✘%f"
}
PROMPT='%F{cyan}%n%f@%F{magenta}%m%f %F{yellow}%~%f $(git_branch)
$(exit_status)
$ '

# KEYBINDINGS
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# QUALITY OF LIFE
setopt AUTO_CD
setopt CORRECT
setopt NO_BEEP
# Run fastfetch only in Kitty and only in interactive shells
if [[ "$TERM" == "xterm-kitty" && -z "$FASTFETCH_SHOWN" ]]; then
  export FASTFETCH_SHOWN=1
  fastfetch
fi
export TERMINAL=kitty

# ZSH AUTO SUGGESTIONS (history)

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Make suggestions subtle gray
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Use history first (fast + accurate)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Accept suggestion with right arrow
bindkey '^[[C' autosuggest-accept

# ZSH SYNTAX HIGHLIGHTING (LIVE)

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Valid command → Green
ZSH_HIGHLIGHT_STYLES[command]='fg=green'

# Invalid command → Red
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'

# Builtins, aliases → Cyan
ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'

# Paths / args → Gray
ZSH_HIGHLIGHT_STYLES[path]='fg=8'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=white'
