#!/usr/bin/env bash
# shellcheck shell=bash

#### ------------------------------------------------------------
#### History & basic bash options
#### ------------------------------------------------------------

# How many lines of history to keep in memory and on disk
HISTSIZE=5000
HISTFILESIZE=10000

# Don't store duplicate lines, compact older duplicates
HISTCONTROL=ignoredups:erasedups

# Append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as a single history entry
shopt -s cmdhist

# Check window size after each command and update LINES/COLUMNS
shopt -s checkwinsize

# Allow recursive globbing (**), if supported
shopt -s globstar 2>/dev/null || true

#### ------------------------------------------------------------
#### Helper: warn if a command is missing
#### ------------------------------------------------------------

ensure_cmd() {
  # usage: ensure_cmd <command-name> <description>
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'WARNING: %s (%s) is not installed or not on PATH.\n' "$1" "$2" >&2
  fi
}

ensure_cmd oh-my-posh  "prompt theming"
ensure_cmd git         "git version control"
ensure_cmd kubectl     "Kubernetes CLI (for completion and k alias"
# ensure_cmd eza       "modern ls replacement (optional)"
# ensure_cmd zoxide    "smart directory jumping (optional)"

#### ------------------------------------------------------------
#### Oh My Posh prompt (bash-native)
#### ------------------------------------------------------------

if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init bash --config "$HOME/dotfiles/shared/oh-my-posh/devops.omp.json")"
fi

#### ------------------------------------------------------------
#### LS / LL / LA: colorized listings (bash-style)
#### ------------------------------------------------------------

# Prefer eza if available, else GNU ls coloring
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first --color=auto'
  alias ll='eza -lha --group-directories-first --color=auto'
  alias la='eza -lha --group-directories-first --color=auto'
else
  # Assume GNU ls (Linux, WSL)
  alias ls='ls --color=auto'
  alias ll='ls -lh'
  alias la='ls -lha'    # closest to oh-my-bash "la"
fi

#### ------------------------------------------------------------
#### Git QoL aliases (prompt git info is via oh-my-posh)
#### ------------------------------------------------------------

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
  # shellcheck disable=SC1090
  source <(kubectl completion bash)
  alias k='kubectl'
  complete -F __start_kubectl k
fi

#### ------------------------------------------------------------
#### Other aliases
#### ------------------------------------------------------------

alias vi='vim'
# Type just "~" + Enter to cd to $HOME
alias '~'='cd ~'

#### ------------------------------------------------------------
#### OPTIONAL: directory jumping with zoxide
#### ------------------------------------------------------------

# if command -v zoxide >/dev/null 2>&1; then
#   eval "$(zoxide init bash)"
# fi


