# shellcheck disable=SC2148
# List directory contents
alias ll='ls -AlhF' # Long list, human readable sizes
alias tree='tree -CF'
alias t='tree -a --noreport --dirsfirst -I ".git|node_modules"'

# Avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ncdu dark theme
alias ncdu="ncdu --color dark"

# Pretty print the path
alias pppath='echo $PATH | tr -s ":" "\n"'

# Export editor for other programs to use
alias e='${EDITOR}' # Open file in default editor

# Functions

#
# Check if command can be used
#
# Usage:command_exists <command> || return 1
#
command_exists() {
  command -v "$@" >/dev/null 2>&1
}

#
# Recursively create directory and cd in it
#
# Usage: mkd <directory_path>
#
mkd() {
  [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" || return 1
}

#
# Alias for git.
#
# Usage: g <command> [<args>]
# With arguments acts like `git`
# Without arguments acts like `git status`
#
g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status
  fi
}

#
# Alias for tmux.
#
# Usage: tms [<arg>]
# With an argument, it creates a new session or attaches to an existing one.
# Without an argument, it creates a new session with the name "${1:-$(whoami)@$(hostname -s)}".
#
tms() {
    tmux -u new-session -A -s "${1:-$(whoami)@$(hostname -s)}"
}

#
# Hide and show username and hostname in bash prompt
#
# Usage: prompt_toggle
#
prompt_toggle() {
    if [ "$PROMPT_TOGGLE" = true ]; then
        export PROMPT_TOGGLE=false
    else
        export PROMPT_TOGGLE=true
    fi
    # Re-source bashrc to apply changes
    # shellcheck source=/dev/null
    . "${HOME}/.bashrc"
}


# vim:filetype=sh:foldmethod=marker:foldlevel=2
