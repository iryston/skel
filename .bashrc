# shellcheck disable=SC2148
# $HOME/.bashrc
#
# @file Configuration file sourced on interactive shells

# Exit if not running interactively in bash
[[ -z "$BASH_VERSION" || "$-" != *i* ]] && return

export SHELL_NAME="bash"
export SHELL_VERSION="${BASH_VERSION}"

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
HISTCONTROL=ignoreboth # Ignore duplicates and space-prefixed lines
HISTSIZE=8000
HISTFILESIZE=10000
export HISTIGNORE="&:bg:bg *:fg:fg *:ll:ll *:ls:ls *:cd:cd *:git add:git add *:git reset:git reset *:mc:mc *:mkdir:mkdir *:pwd:exit:date:* --help:vault*:e:e *:g:g *:mkd:mkd *"
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
export PROMPT_COMMAND

# Bash 4+ specific features
((BASH_VERSINFO[0] >= 4)) && {
  shopt -s dirspell  # Directory typo correction in completion
  shopt -s globstar  # Enable ** for recursive matching
}

# Set chroot identifier if available
[[ -z "${debian_chroot:-}" && -r /etc/debian_chroot ]] &&
  debian_chroot=$(</etc/debian_chroot)

# Prompt configuration
enable_color_prompt=yes
if [[ -n "$enable_color_prompt" ]]; then
  if command -v tput &>/dev/null && tput setaf 1 &>/dev/null; then
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [[ "$color_prompt" == yes ]]; then
  if ((EUID == 0)); then
    # Root user
    if [ "$PROMPT_TOGGLE" = true ]; then
      PS1='${debian_chroot:+($debian_chroot)}\[\e[38;5;75m\]\w\n\[\e[90m\]\t\[\e[0m\] \[\e[38;5;73m\][\[\e[37m\]\j\[\e[38;5;73m\]]\[\e[0m\] $(if [ $? -eq 0 ]; then echo "\[\e[32;1m\]"; else echo "\[\e[91;1m\]"; fi)\$\[\e[0m\] '
    else
      PS1='${debian_chroot:+($debian_chroot)}\[\e[91m\]\u\[\e[90m\]@\[\e[38;5;173m\]\h\[\e[0m\]:\[\e[38;5;75m\]\w\n\[\e[90m\]\t\[\e[0m\] \[\e[38;5;73m\][\[\e[37m\]\j\[\e[38;5;73m\]]\[\e[0m\] $(if [ $? -eq 0 ]; then echo "\[\e[32;1m\]"; else echo "\[\e[91;1m\]"; fi)\$\[\e[0m\] '
    fi
  else
    # Non-root user
    if [ "$PROMPT_TOGGLE" = true ]; then
      PS1='${debian_chroot:+($debian_chroot)}\[\e[38;5;75m\]\w\n\[\e[90m\]\t\[\e[0m\] \[\e[38;5;73m\][\[\e[37m\]\j\[\e[38;5;73m\]]\[\e[0m\] $(if [ $? -eq 0 ]; then echo "\[\e[32;1m\]"; else echo "\[\e[91;1m\]"; fi)\$\[\e[0m\] '
    else
      PS1='${debian_chroot:+($debian_chroot)}\[\e[32m\]\u\[\e[90m\]@\[\e[38;5;173m\]\h\[\e[0m\]:\[\e[38;5;75m\]\w\n\[\e[90m\]\t\[\e[0m\] \[\e[38;5;73m\][\[\e[37m\]\j\[\e[38;5;73m\]]\[\e[0m\] $(if [ $? -eq 0 ]; then echo "\[\e[32;1m\]"; else echo "\[\e[91;1m\]"; fi)\$\[\e[0m\] '
    fi
  fi
else
  if [ "$PROMPT_TOGGLE" = true ]; then
    PS1='${debian_chroot:+($debian_chroot)}\w\$ '
  else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
  fi
fi
unset color_prompt enable_color_prompt

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

# vim:filetype=sh:foldmethod=marker:foldlevel=2
