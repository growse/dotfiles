# shellcheck shell=bash disable=SC2034
# Internal commands
_path_add() {
    # Adds a directory to $PATH, but only if it isn't already present.
    # http://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there/39995#39995
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1${PATH:+":$PATH"}"
    fi
}

_command_exists() {
    type "$1" &>/dev/null
}

# Paths and environment variables for non-interactive shells
_path_add ~/.local/bin
_path_add ~/.krew/bin
_path_add ~/.rbenv/bin
_path_add ~/.fly/bin
_path_add ~/.rd/bin
_path_add /opt/homebrew/bin
_path_add ~/Library/Android/sdk/platform-tools
_path_add ~/Android/Sdk/cmdline-tools/latest/bin
_path_add ~/Android/Sdk/platform-tools
_path_add ~/Android/Sdk/emulator
export GOPATH=~/Projects/golang/
export GPG_TTY=$(tty)
export HELM_NAMESPACE="helmthings"

# If this is a non-interactive shell, return
if [[ $- != *i* ]]; then
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

# Environment variables for interactive shells
export CLICOLOR=1
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

# Aliases and commands
alias ls='ls -lah'
alias ll='ls -laht'
alias pip_upgrade='pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U'
alias dmesg='dmesg -T'
alias tail='tail -f -n500'
alias s='systemctl'
alias j='journalctl'
alias n='networkctl'

# AWS CLI shortcuts
function aws_truncate_log_group() {
	LOG_GROUP_NAME=$1
	echo Truncating log group "$LOG_GROUP_NAME"
	aws logs describe-log-streams --log-group-name "$LOG_GROUP_NAME" --query 'logStreams[*].logStreamName' -- | jq .[]|xargs -I {} sh -c "echo '{}' && aws logs delete-log-stream  --log-group-name $LOG_GROUP_NAME --log-stream-name '{}'"
}

## Bash completion
if _command_exists stern; then source <(stern --completion=bash); fi
if _command_exists helm; then source <(helm completion bash); fi
if _command_exists gh; then source <(gh completion -s bash); fi
if _command_exists flux; then source <(flux completion bash); fi
if _command_exists kubectl; then source <(kubectl completion bash); fi
if _command_exists glab; then source <(glab completion); fi
if type brew &>/dev/null; then
    HOMEBREW_PREFIX="$(brew --prefix)"
    if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
        # shellcheck source=/dev/null
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
        done
    fi
fi
##

alias ls='ls -lah --color'

mkcd() {
    dir="$*"
    mkdir -p "$dir" && cd "$dir" || exit
}
extract() {
    if [ -f "$1" ]; then
        case $1 in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) rar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
if _command_exists hub; then
    hub alias -s bash
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
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

export CLICOLOR=YES
if _command_exists dircolors; then
    eval "$(dircolors --bourne-shell ~/.dir_colors)"
fi

## rbenv
if _command_exists rbenv; then
    eval "$(rbenv init -)"
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
export HISTFILESIZE=
export HISTSIZE=
shopt -s histappend # don't overwrite history file after each session

# on every prompt, save new history to dedicated file and recreate full history
# by reading all files, always keeping history from current session on top.
update_history() {
    history -a "${HISTFILE}".$$
    history -c
    history -r # load common history file
    # load histories of other sessions
    for f in $(/bin/ls "${HISTFILE}".[0-9]* 2>/dev/null | grep -v "${HISTFILE}.$$\$"); do
        history -r "$f"
    done
    history -r "${HISTFILE}.$$" # load current session history
}
if [[ "$PROMPT_COMMAND" != *update_history* ]]; then
    export PROMPT_COMMAND="update_history; $PROMPT_COMMAND"
fi

# merge session history into main history file on bash exit
merge_session_history() {
    if [ -e ${HISTFILE}.$$ ]; then
        cat ${HISTFILE}.$$ >>"$HISTFILE"
        \rm ${HISTFILE}.$$
    fi
}
trap merge_session_history EXIT

# detect leftover files from crashed sessions and merge them back
active_shells=$(pgrep -- "$(ps -p $$ -o comm=)")
if [ -n "$active_shells" ]; then
    grep_pattern=$(for pid in $active_shells; do echo -n "-e \.${pid}\$ "; done)
    orphaned_files=$(/bin/ls "$HISTFILE".[0-9]* 2>/dev/null | grep -v "$grep_pattern")
fi

if [ -n "$orphaned_files" ]; then
    echo Merging orphaned history files:
    for f in $orphaned_files; do
        echo "  $(basename "$f")"
        cat "$f" >>"$HISTFILE"
        \rm "$f"
    done
    echo "done."
fi

# Powerline
function _powerline_rust() {
    if _command_exists findmnt && /bin/findmnt -oFSTYPE -T . | grep -q 9p; then
        PS1="$($(which powerline-rust) -git -error $? -shell bash)"
    else
        PS1="$($(which powerline-rust) -error $? -shell bash)"
    fi
}

_command_exists powerline-rust
if [[ ($? == 0) && "$PROMPT_COMMAND" != *_powerline-rust* ]]; then
    PROMPT_COMMAND="_powerline_rust; $PROMPT_COMMAND"
fi

## SSH Agent
env=~/.ssh/agent.env

agent_load_env() { test -f "$env" && . "$env" >|/dev/null; }

agent_start() {
    (
        umask 077
        ssh-agent >|"$env"
    )
    . "$env" >|/dev/null
}

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(
    ssh-add -l >|/dev/null 2>&1
    echo $?
)

if [ ! "$SSH_AUTH_SOCK" ] || [ "$agent_run_state" = 2 ]; then
    agent_start
fi

unset env

## BRoot
[[ -f ~/.config/broot/launcher/bash/rc ]] && source ~/.config/broot/launcher/bash/br

## NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# OSX
if [[ $(uname) == "Darwin" ]]; then
    if _command_exists gfind; then alias find='gfind'; fi
    alias locate='mdfind'
fi

# Run local config
[[ -f ~/.bashrc.local ]] && . ~/.bashrc.local

[[ -f ~/.cargo/env ]] && source "$HOME/.cargo/env"

[[ -f ~/.config/broot/launcher/bash/br ]] && source /home/growse/.config/broot/launcher/bash/br

[[ -d ~/Android/Sdk ]] && export ANDROID_HOME=~/Android/Sdk

[[ -f ~/.sdkman/bin/sdkman-init.sh ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

[[ -f ~/.poetry/env ]] && source ~/.poetry/env

bind 'set enable-bracketed-paste on'
