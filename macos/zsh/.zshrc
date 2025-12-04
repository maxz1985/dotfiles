#### ------------------------------------------------------------
#### Basic safety / options
#### ------------------------------------------------------------

# History settings (rough equivalent of PSReadLine history)
HISTSIZE=5000
SAVEHIST=5000
HISTFILE="$HOME/.zsh_history"

setopt append_history          # don't overwrite history
setopt share_history           # share history between sessions
setopt inc_append_history      # write immediately
setopt hist_ignore_dups        # ignore duplicates
setopt hist_ignore_space       # ignore commands starting with space

# Completion system
autoload -Uz compinit
compinit

#### ------------------------------------------------------------
#### Helper: warn if dependency is missing
#### (analogous to Install-RequiredModule, but non-intrusive)
#### ------------------------------------------------------------

ensure_cmd() {
  # usage: ensure_cmd <command-name> <description>
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'WARNING: %s (%s) is not installed or not on PATH.\n' "$1" "$2" >&2
  fi
}

# Check main tools (no auto-install, just warnings)
ensure_cmd oh-my-posh  "prompt theming"
ensure_cmd git         "git version control"
ensure_cmd kubectl     "Kubernetes CLI (for completion and k alias"
# ensure_cmd eza       "modern ls replacement (optional)"

#### ------------------------------------------------------------
#### Oh My Posh prompt
#### ------------------------------------------------------------

if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config "$HOME/dotfiles/shared/oh-my-posh/devops.omp.json")"
fi

#### ------------------------------------------------------------
#### LS / LL / LA: colorized listings (similar to pwsh profile)
#### ------------------------------------------------------------

# Prefer eza if installed, else colorized ls
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first --color=auto'
  alias ll='eza -lha --group-directories-first --color=auto'
  alias la='eza -lha --group-directories-first --color=auto'
else
  # macOS vs Linux color flags
  if [[ "$OSTYPE" == darwin* ]]; then
    alias ls='ls -G'
  else
    alias ls='ls --color=auto'
  fi

  alias ll='ls -lh'
  alias la='ls -lha'   # closest to your PowerShell la
fi

#### ------------------------------------------------------------
#### Git enhancements (completion + basic config)
#### ------------------------------------------------------------

# zsh already has good git completion once compinit runs.
# Extra: common git aliases if you want them.
alias gs='git status'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'

#### ------------------------------------------------------------
#### kubectl completion + k alias
#### ------------------------------------------------------------

if command -v kubectl >/dev/null 2>&1; then
  # zsh-native completion
  source <(kubectl completion zsh)
  alias k='kubectl'
fi

#### ------------------------------------------------------------
#### Other aliases
#### ------------------------------------------------------------

alias vi='vim'
alias '~'='cd ~'

#### ------------------------------------------------------------
#### OPTIONAL: directory jumping with zoxide (mirrors pwsh comment)
#### ------------------------------------------------------------

# if command -v zoxide >/dev/null 2>&1; then
#   eval "$(zoxide init zsh)"
# fi

# --- Local machine-specific overrides (not in repo) ---
if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi
