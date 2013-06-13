node=$(uname -n)

# Terminal.
# =========
export LC_ALL="en_US.utf8"
export LANG=$LC_ALL

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob
bindkey -v
bindkey "^R" history-incremental-search-backward

zstyle :compinstall filename '/home/mason/.zshrc'

autoload -Uz compinit
compinit

host_color="white"
case $(uname -n) in
  ip-*)
    host_color="magenta"
    ;;
  inkling)
    host_color="magenta"
    ;;
  develop*)
    host_color="blue"
    ;;
  admin*)
    host_color="red"
    ;;
esac
PROMPT="

%D{%F %T}, %(!.%F{black}%K{red}.)%n%(!.%f%k.)@%F{$host_color}%M%f, %B%F{white}%d%b
?%? %B>%b "



# Environment.
# ============
PATH="$PATH:$HOME/bin:$HOME/.local/bin"

export EDITOR=vim
export XMLLINT_INDENT="    "
export GREP_COLOR='1;32'
export GIT_SSH="$HOME/dotfiles/git-ssh.sh"



# Aliases and functions.
# ======================
alias ls="ls --color"
alias lsnc="ls --color=never"
alias ll="ls -lh"
alias la="ls -A"
alias lla="ll -A"
alias tmux='tmux -2'

cdn-assets() {
  local url
  local host
  local assets

  url=$1
  host=$2

  assets=$(
    curl -Ss $url |
    sed 's/\(<a[^>]*>\)/\n\1\n/g;s/\(<img [^>]*>\)/\n\1\n/g;s/\(<link [^>]*>\)/\n\1\n/g;s/\(<script [^>]*>\)/\n\1\n/g' |
    grep -o "http:\/\/$host\/[^\"']*")

  echo $assets
}

export TENPER_VERBOSE="true"
export TENPER_TMUX_COMMAND="tmux -2"
if [[ -n "$TENPER_VIRTUALENV" ]] then
  source $TENPER_VIRTUALENV
fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

unset node
