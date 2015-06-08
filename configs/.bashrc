test -r /sw/bin/init.sh && . /sw/bin/init.sh
bind "set completion-ignore-case on"
if [[ `uname` == 'Darwin' ]]; then
  alias vim='/Applications/MacVim.app/Contents/MacOS/Vim' # Because Mac's built-in vim is old. :/
fi
alias nvim='nvim -u ~/.vimrc'

export EDITOR=/usr/bin/vim

# Ignore duplicates and empty lines in command history:
export HISTCONTROL=ignoreboth:erasedups

function ranger-cd {
    tempfile='/tmp/rangertmpdirtmp'
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

bind '"\C-o":"ranger-cd\C-m"'

function ls() { command ls -lh --color "$@" | less -RX --quit-if-one-screen ; }
  # using a function instead, so that we can put flags on ls still
  # the -X is not required in screen, but is, for some reason, without screen. Seen so far only with Ubuntu's Terminal Program
function sl() { command ls -lh --color "$@" | less -RX --quit-if-one-screen ; }
function s() { command ls -lh --color "$@" | less -RX --quit-if-one-screen ; }
function l() { command ls -lh --color "$@" | less -RX --quit-if-one-screen ; }
function ll() { command ls -lh --color "$@" | less -RX --quit-if-one-screen ; }

alias grep='grep -n --colour'
alias matlab='matlab -nosplash -nodesktop'
alias less='less -R' #allow less to show colours properly
alias lessp='less -X --quit-if-one-screen'
alias r='ranger'
alias p='ipython --pylab'
alias info='info --vi-keys'
alias ip_external='curl -s icanhazip.com'
alias gdiff='git diff --no-index'
alias gdiffw='git diff --no-index --word-diff'

function _git_prompt() {
    local git_status="`git status -unormal 2>&1`"
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            local ansi=42 # green      --> clean directory
        elif [[ "$git_status" =~ Untracked\ files ]]; then
            local ansi=43 # yellow     --> new file
        elif [[ "$git_status" =~ Changes\ not\ staged\ for\ commit ]]; then
            local ansi=45 # pink       --> unstaged changes
        else
            local ansi=46 # light blue --> all is staged. We're ready to commit.
        fi
        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
            test "$branch" != master || branch=' '
        else
            # Detached HEAD.  (branch=HEAD is a faster alternative.)
            branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null ||
                echo HEAD`)"
        fi
        echo -n '\[\e[0;37;'"$ansi"';1m\]'"$branch"'\[\e[0m\] '
    fi
}
function _prompt_command() {
    PS1="`_git_prompt`""\`if [ \$? = 0 ]; then if [ $UID -eq "0" ]; then echo '\[\e[35m\]'; else echo '\[\e[32m\]'; fi; else echo \[\e[31m\]; fi\`[\u@\h \w]\\$ \[\e[0m\]"
}
PROMPT_COMMAND=_prompt_command

#########################
#Here are the backslash-escape special characters that have meaning to bash:
#
#       \a     an ASCII bell character (07)
#       \d     the date  in  "Weekday  Month  Date"  format
#              (e.g., "Tue May 26")
#       \e     an ASCII escape character (033)
#       \h     the hostname up to the first `.'
#       \H     the hostname
#       \j     the  number of jobs currently managed by the shell
#       \l     the basename of the shell's terminal device name
#       \n     newline
#       \r     carriage return
#       \s     the  name  of  the shell, the basename of $0
#              (the portion following the final slash)
#       \t     the current time in 24-hour HH:MM:SS format
#       \T     the current time in 12-hour HH:MM:SS format
#       \@     the current time in 12-hour am/pm format
#       \u     the username of the current user
#       \v     the version of bash (e.g., 2.00)
#       \V     the release of bash,  version  +  patchlevel
#              (e.g., 2.00.0)
#       \w     the current working directory
#       \W     the  basename  of the current working direcory
#       \!     the history number of this command
#       \#     the command number of this command
#       \$     if the effective UID is 0, a #, otherwise a $
#       \nnn   the character corresponding to the octal number nnn
#       \\     a backslash
#       \[     begin a sequence of non-printing characters,
#              which could be used to embed a terminal control
#              sequence into the prompt
#       \]     end a sequence of non-printing characters
#
#Colours In Bash:
#
#      Black       0;30     Dark Gray     1;30
#      Blue        0;34     Light Blue    1;34
#      Green       0;32     Light Green   1;32
#      Cyan        0;36     Light Cyan    1;36
#      Red         0;31     Light Red     1;31
#      Purple      0;35     Light Purple  1;35
#      Brown       0;33     Yellow        1;33
#      Light Gray  0;37     White         1;37
#
#Here is an example borrowed from the Bash-Prompt-HOWTO:
#
#      PS1="\[\033[1;30m\][\[\033[1;34m\]\u\[\033[1;30m\]@\[\033[0;35m\]\h\[\033[1;30m\]] \[\033[0;37m\]\W \[\033[1;30m\]\$\[\033[0m\] "
#
#This one sets up a prompt like this: 
#      [user@host] directory $
#
#Break down:
#
#      \[\033[1;30m\] - Sets the color for the characters that follow it. Here 1;30 will set them to Dark Gray.
#      \u \h \W \$ - Look to the table above
#      \[\033[0m\] - Sets the colours back to how they were originally.
#########################



# Enable bash completion for git
# The source is downloaded from here: https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
source ~/.git-completion.bash

# alias g to git, and allow autocompletion for it as well
alias g='git'
alias gl='git l'
alias gll='git ll'
alias gd='git diff'
complete -o default -o nospace -F _git g

# alias c to cargo, ct is cargo test, cr is cargo run
alias c='cargo'
alias ct='cargo test'
alias cr='cargo run'

# curses (CLI) alternative to gitk
alias t='tig --all'
alias tl='tig'
alias ts='tig status'

# Use LS_COLORS
eval $( dircolors -b $HOME/.LS_COLORS)

# Add my git bash scripts
export PATH=~/Dropbox/Projects/git/scripts:$PATH

# Add rubygems
export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"

# Add cabal
export PATH=~/.cabal/bin:$PATH
alias ghcmod='ghc-mod'

# For screen, do all the git stuff
# AND set window title to be currently running command
if [[ $TERM == 'screen' ]]; then
  function _run_first() {
    PS1="`_git_prompt`""\`if [ \$? = 0 ]; then if [ $UID -eq "0" ]; then echo '\[\e[35m\]'; else echo '\[\e[32m\]'; fi; else echo \[\e[31m\]; fi\`[\u@\h \w]\\$ \[\e[0m\]"
    echo -ne "\033k\033\\\\"
  }
  PROMPT_COMMAND=_run_first
fi

#Nessus path
export PATH=/opt/nessus/sbin:$PATH
export PATH=/opt/nessus/bin:$PATH

## nasl
export FEED=~/nasl
export NBIN=~/nbin
export NASL_REPO=~/plugin_dev
export NBIN_REPO=~/plugin_dev/nbin
