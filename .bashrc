# shellcheck disable=SC2148
# $HOME/.bashrc
#
# @file Configuration file sourced on interactive shells

# Exit if not running interactively in bash
[[ -z "$BASH_VERSION" || "$-" != *i* ]] && return

export SHELL_NAME="bash"
export SHELL_VERSION="${BASH_VERSION}"

if [ "$(id -u)" -eq 0 ]; then
  PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
else
  PATH="/usr/local/bin:/usr/bin:/bin"
fi
export PATH

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

export TERM="xterm"

# Sensible Defaults
stty -ixon            # Disable start/stop output control
set -o notify         # Notify about terminating background jobs
shopt -s cdspell      # Correct typos in directory names for cd
shopt -s checkwinsize # Ensure LINES/COLUMNS match window size
shopt -s cmdhist      # Join multi-line commands
shopt -s dotglob      # Expand filenames starting with dot
shopt -s extglob      # Enable extended pattern matching
shopt -s histappend   # Append to history on shell exit
shopt -s hostcomplete # Host completion for words containing @
shopt -s nocaseglob   # Case-insensitive globbing

# History configuration
HISTSIZE=8000
HISTFILESIZE=10000
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
export PROMPT_COMMAND

# Bash 4+ specific features
((BASH_VERSINFO[0] >= 4)) && {
  shopt -s dirspell  # Directory typo correction in completion
  shopt -s globstar  # Enable ** for recursive matching
}

# Source .bash_prompt if available
# shellcheck source=/dev/null
[[ -f "${HOME}/.bash_prompt" ]] && . "${HOME}/.bash_prompt"

# Color support for ls/grep
if command -v dircolors &>/dev/null; then
  if [[ -r "${HOME}/.dircolors" ]]; then
    LS_COLORS="$(dircolors -b "${HOME}/.dircolors" | grep '^LS_COLORS=' | cut -d\' -f2)"
  else
    LS_COLORS="$(dircolors -b | grep '^LS_COLORS=' | cut -d\' -f2)"
  fi
  export LS_COLORS
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
elif [[ "$OSTYPE" == darwin* ]]; then
  alias ls='ls -G'  # macOS fallback
fi

# GCC output colors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Less configuration
export LESS="-imwFRX"
export PAGER="less"
export MANPAGER="$PAGER"

export VISUAL="$EDITOR"

# Ripgrep config
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/ripgrep/ripgreprc"

# Source aliases if available
# shellcheck source=/dev/null
[[ -f "${HOME}/.bash_aliases" ]] && . "${HOME}/.bash_aliases"

# Load completions
if ! shopt -oq posix; then
  # shellcheck source=/dev/null
  [[ -f "/usr/share/bash-completion/bash_completion" ]] && . "/usr/share/bash-completion/bash_completion" ||
  [[ -f "/etc/bash_completion" ]] && . "/etc/bash_completion"
fi

# Source .bashrc.local if available
# shellcheck source=/dev/null
[[ -f "${HOME}/.bashrc.local" ]] && . "${HOME}/.bashrc.local"

# Remove duplicates from $PATH
function remove_path_duplicates {
  local OLD_PATH=$IFS
  IFS=:
  local NEWPATH=
  local -A EXISTS
  for p in $PATH; do
    if [ -z "${EXISTS[$p]}" ]; then
      NEWPATH=${NEWPATH:+$NEWPATH:}$p
      EXISTS[$p]=yes
    fi
  done
  IFS=$OLD_PATH
  export PATH=$NEWPATH
}
remove_path_duplicates


# vim:filetype=sh:foldmethod=marker:foldlevel=2
