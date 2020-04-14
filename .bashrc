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
export GPG_TTY=$(tty)
export HELM_NAMESPACE="helmthings"


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
alias ll='ls -laht'
alias v='ls -ahlO'
alias cls='clear'
alias whatismyip="curl 'http://api.ipify.org?format=json'"
alias json='python -mjson.tool'
alias pip_upgrade='pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U'
alias dmesg='dmesg -T'
alias tail='tail -f -n500'
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

## RVM
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
if [[ `uname` == "Darwin" ]]; then
    alias find='ffind'
    alias locate='mdfind'
fi

## awscli complete
complete -C aws_completer aws

## History sanity https://gist.github.com/jan-warchol/89f5a748f7e8a2c9e91c9bc1b358d3ec
# Synchronize history between bash sessions
#
# Make history from other terminals available to the current one. However,
# don't mix all histories together - make sure that *all* commands from the
# current session are on top of its history, so that pressing up arrow will
# give you most recent command from this session, not from any session.
#
# Since history is saved on each prompt, this additionally protects it from
# terminal crashes.


# keep unlimited shell history because it's very useful
export HISTFILESIZE=-1
export HISTSIZE=-1
shopt -s histappend   # don't overwrite history file after each session


# on every prompt, save new history to dedicated file and recreate full history
# by reading all files, always keeping history from current session on top.
update_history () {
  history -a ${HISTFILE}.$$
  history -c
  history -r  # load common history file
  # load histories of other sessions
  for f in `/bin/ls ${HISTFILE}.[0-9]* 2>/dev/null | grep -v "${HISTFILE}.$$\$"`; do
    history -r $f
  done
  history -r "${HISTFILE}.$$"  # load current session history
}
if [[ "$PROMPT_COMMAND" != *update_history* ]]; then
  export PROMPT_COMMAND="update_history; $PROMPT_COMMAND"
fi

# merge session history into main history file on bash exit
merge_session_history () {
  if [ -e ${HISTFILE}.$$ ]; then
    cat ${HISTFILE}.$$ >> $HISTFILE
    \rm ${HISTFILE}.$$
  fi
}
trap merge_session_history EXIT


# detect leftover files from crashed sessions and merge them back
active_shells=$(pgrep `ps -p $$ -o comm=`)
grep_pattern=`for pid in $active_shells; do echo -n "-e \.${pid}\$ "; done`
orphaned_files=`/bin/ls $HISTFILE.[0-9]* 2>/dev/null | grep -v $grep_pattern`

if [ -n "$orphaned_files" ]; then
  echo Merging orphaned history files:
  for f in $orphaned_files; do
    echo "  `basename $f`"
    cat $f >> $HISTFILE
    \rm $f
  done
  echo "done."
fi

# Powerline
if [[ $(uname -m) != *"arm"* ]] ; then
    if [[ -f /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh ]]; then
        . /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
    elif [[ -f /usr/share/powerline/bindings/bash/powerline.sh ]] ; then
        . /usr/share/powerline/bindings/bash/powerline.sh
    fi
fi

## SSH Agent
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
fi

unset env

## BRoot
[[ -f ~/.config/broot/launcher/bash/rc ]] &&  source /home/growse/.config/broot/launcher/bash/br

## NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Run local config
if [ -f ~/.bashrc.local ]; then
	. ~/.bashrc.local
fi


source /home/growse/.config/broot/launcher/bash/br
