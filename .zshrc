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
  inkling)
    host_color="magenta"
    ;;
  nutmeg)
    host_color="blue"
    ;;
  boudica)
    host_color="red"
    ;;
esac
PROMPT="

%D{%F %T}, %(!.%F{black}%K{red}.)%n%(!.%f%k.)@%F{$host_color}%M%f, %B%F{white}%d%b
?%? %B>%b "



# Environment.
# ============
if [[ $node == "boudica" ]]; then
    source /usr/bin/virtualenvwrapper.sh
else
  source /etc/bash_completion.d/virtualenvwrapper
fi
PATH="$PATH:$HOME/bin:$HOME/.local/bin"

export EDITOR=vim
export SVN_EDITOR=$EDITOR
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

alias fc-start='vboxmanage startvm "FC14 Sandbox" --type headless'
alias fc-stop='ssh root@10.0.0.101 "halt -p"'
alias fc-ssh='ssh root@10.0.0.101'
alias tmux='TERM=screen-256color tmux'


ssh-add-all() {
    keys=(
        "$HOME/.ssh/mstaugler-ud"
        "$HOME/.ssh/id_rsa"
    )

    for ii in ${keys[*]}; do
        ssh-add $ii
    done
}

alias fg="find-grep"
find-grep() {
    search=$1
    shift

    find . -path '*.git' -prune -o -path '*cache' -prune -o -type f $* -print0 | xargs -0 grep --color "$search"
}

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

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
