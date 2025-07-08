## List directory contents
alias ll='ls -AlhF' # Long list, human readable sizes
alias tree='tree -CF'
alias t='tree -a --noreport --dirsfirst -I ".git|node_modules"'

## ncdu dark theme
alias ncdu="ncdu --color dark"

## Pretty print the path
alias pppath='echo $PATH | tr -s ":" "\n"'

## TMUX create new session or attach if exists
alias tms='tmux -u new-session -A -s "$(hostname -s)"'

# Check for editors and set aliases
for edtr in nvim vim nano mcedit vi; do
  if command -v "$edtr" >/dev/null 2>&1; then
    case "$edtr" in
    nvim)
      alias ee='nvim -u NONE -U NONE -i NONE -N -n' # No config, no swap, no plugins
      alias vimdiff='nvim -dR'                      # Diff mode (read-only)
      EDITOR='nvim'
      ;;
    vim)
      alias ee='vim -u NONE -U NONE -i NONE -N -n' # No config, no swap, no plugins
      EDITOR='vim'
      ;;
    nano)
      alias ee='nano -I -R' # No rc files, restricted mode
      EDITOR='nano'
      ;;
    mcedit)
      alias ee='mcedit -b' # B/W mode, no syntax highlighting
      EDITOR='mcedit'
      ;;
    vi)
      alias ee='vi' # No clean mode available
      EDITOR='vi'
      ;;
    esac
    # Export editor for other programs to use
    export EDITOR VISUAL="$EDITOR"
    alias e='${EDITOR}' # Open file in default editor
    break
  fi
done

## Functions

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
    tmux -f "${XDG_CONFIG_HOME}/tmux/tmux.conf" -u new-session -A -s "${1:-$(whoami)@$(hostname -s)}"
}
