# Internal commands
_path_add() {
    # Adds a directory to $PATH, but only if it isn't already present.
    # http://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there/39995#39995
    if [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$PATH:$1"
    fi
}
_dir_chomp () {
    # Shortens the working directory.
    # First param is pwd, second param is the soft limit.
    # From http://stackoverflow.com/questions/3497885/code-challenge-bash-prompt-path-shortener/3499237#3499237
    # which asks for the shortest solution in characters, explaining the complete lack of readability or clarity.
    local IFS=/ c=1 n d
    local p=(${1/#$HOME/\~}) r=${p[*]}
    local s=${#r}
    while ((s>$2&&c<${#p[*]}-1))
    do
        d=${p[c]}
        n=1;[[ $d = .* ]]&&n=2
        ((s-=${#d}-n))
        p[c++]=${d:0:n}
    done
    echo "${p[*]}"
}
_command_exists() {
    type "$1" &> /dev/null ;
}
_set_exit_color() {
    if [[ $? != "0" ]]; then EXITCOLOR=$C_RED; else EXITCOLOR=$C_GREEN; fi
}
_set_git_prompt_string() {
    if type -t __git_ps1 &> /dev/null; then
        PS1_GIT="$(__git_ps1)"
    fi 
}

_set_virtualenv_prompt_string() {
	if [[ ! -z "$VIRTUAL_ENV" ]]; then
		PS1_VIRTUALENV=" [`basename \"$VIRTUAL_ENV\"`]"
	else
		PS1_VIRTUALENV=""
	fi
}


# Paths and environment variables for non-interactive shells
PATH="/usr/local/sbin:/usr/local/bin:$PATH" # These REALLY need to come first
_path_add ~/Applications/bin
export GOPATH=~/Projects/golang/
export ANDROID_HOME=/opt/android-sdk
export GPG_TTY=$(tty)

# If this is a non-interactive shell, return
if [[ $- != *i* ]]
then
  return
fi

# Prompt: define colors
C_DEFAULT="\[\033[m\]"
C_WHITE="\[\033[1m\]"
C_BLACK="\[\033[30m\]"
C_RED="\[\033[31m\]"
C_GREEN="\[\033[32m\]"
C_YELLOW="\[\033[33m\]"
C_BLUE="\[\033[34m\]"
C_PURPLE="\[\033[35m\]"
C_CYAN="\[\033[36m\]"
C_LIGHTGRAY="\[\033[37m\]"
C_DARKGRAY="\[\033[1;30m\]"
C_LIGHTRED="\[\033[1;31m\]"
C_LIGHTGREEN="\[\033[1;32m\]"
C_LIGHTYELLOW="\[\033[1;33m\]"
C_LIGHTBLUE="\[\033[1;34m\]"
C_LIGHTPURPLE="\[\033[1;35m\]"
C_LIGHTCYAN="\[\033[1;36m\]"
C_BG_BLACK="\[\033[40m\]"
C_BG_RED="\[\033[41m\]"
C_BG_GREEN="\[\033[42m\]"
C_BG_YELLOW="\[\033[43m\]"
C_BG_BLUE="\[\033[44m\]"
C_BG_PURPLE="\[\033[45m\]"
C_BG_CYAN="\[\033[46m\]"
C_BG_LIGHTGRAY="\[\033[47m\]"

# Prompt: Set variables
MAX_WD_LENGTH="50"
if [[ $TERM == screen* ]] && [ -n "$TMUX" ]; then
    PS1_HOSTNAME=
else
    PS1_HOSTNAME="$(whoami)@$HOSTNAME:"
fi
#PROMPT_COMMAND='_set_exit_color;_set_git_prompt_string;_set_virtualenv_prompt_string;PS1="${EXITCOLOR}[${PS1_HOSTNAME}$(_dir_chomp "$(pwd)" $MAX_WD_LENGTH)${C_YELLOW}${PS1_VIRTUALENV}${PS1_GIT}${EXITCOLOR}]\$${C_DEFAULT} "'



# Environment variables for interactive shells
export CLICOLOR=1
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

# Aliases and commands
alias ls='ls -lah'
alias v='ls -ahlO'
alias cls='clear'
alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"
alias whatismyip="curl 'http://api.ipify.org?format=json'"
alias json='python -mjson.tool'
alias pip_upgrade='pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U'
alias dmesg='dmesg -T'
alias tail='tail -f -n500'
alias it="sudo apt-get install \$(history -p !apt-cache:2)"
alias weather='curl wttr.in/london'
uname=`uname`
if [[ $uname == 'Linux' ]]; then
	alias ls='ls -lah --color'
else
	alias ls='ls -lah'
fi
	
mkcd() {
    dir="$*";
    mkdir -p "$dir" && cd "$dir";
}
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xjf $1      ;;
            *.tar.gz)   tar xzf $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      rar x $1        ;;
            *.gz)       gunzip $1       ;;
            *.tar)      tar xf $1       ;;
            *.tbz2)     tar xjf $1      ;;
            *.tgz)      tar xzf $1      ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
    esac
    else
        echo "'$1' is not a valid file"
    fi
}
if _command_exists hub; then
	`hub alias -s bash`
fi

# Show the fortune while we set up other things
if _command_exists fortune && [ "$TERM_PROGRAM" != "DTerm" ]; then
	fortune
	echo
fi

if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
if _command_exists dircolors; then
    eval `dircolors --bourne-shell ~/.dir_colors`
fi

# Run local config
if [ -f ~/.bashrc.local ]; then
	. ~/.bashrc.local
fi


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
if [[ `uname` == "Darwin" ]]; then
    alias find='ffind'
    alias locate='mdfind'
fi

#awscli complete
complete -C aws_completer aws

#History sanity
shopt -s histappend
  export HISTSIZE=100000
  export HISTFILESIZE=100000
  export HISTCONTROL=ignoredups:erasedups
  export PROMPT_COMMAND="history -a;history -c;history -r;$PROMPT_COMMAND"


if [[ $(uname -m) != *"arm"* ]] ; then
    if [[ -f /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh ]]; then
        . /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
    elif [[ -f /usr/share/powerline/bindings/bash/powerline.sh ]] ; then
        . /usr/share/powerline/bindings/bash/powerline.sh
    fi
fi

if [[ -z ${SSH_CLIENT+x} ]] ; then
    # Set SSH to use gpg-agent
    unset SSH_AGENT_PID
    if [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]] ; then
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    fi

    # Set GPG TTY
    export GPG_TTY=$(tty)

    # Refresh gpg-agent tty in case user switches into an X session
    gpg-connect-agent updatestartuptty /bye >/dev/null

fi
