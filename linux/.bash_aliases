#!/bin/bash
#
# @author Stephen Dunn (snd)
# @since April 1, 2016
# @updated July 26, 2016
#
# Description:
# A minimal (useful) starting point for a Debian-based OS.
# Aliases common commands to cut down on verbosity.
#
# Installation:
# 1) Backup current settings:
#    cp -f ~/.bash_aliases ~/.bash_aliases.bak
# 2) Copy this file to ~/.bash_aliases, e.g.:
#    cp -f ~/Downloads/.bash_aliases ~/.bash_aliases
# 3) To import new settings into current session:
#    source ~/.bash_aliases
# 4) You can now enter 'rs' to refresh your term from the file, and use
#    'upd', 'upg', 'u', etc. as defined below to keep up-to-date
#
# Notes:
# - change the default editors if you don't like/have vim + sublime
# - naturally, assumes no conflicts between your other aliases / bash settings
# - commands are listed in order of estimated utility to save you search time
# - see the provided screenrc for a GNU screen integration example
# - see the corresponding bashrc for other minor integration options
#   - e.g., if you want proper colors your bashrc should have
#
#         export TERM=xterm-256color
#
#     or an equivalent statement enabling more than 16 colors in your term

###############################################################################
# default apps
###############################################################################

export MY_TERM='lxterminal --geometry=160x40'
export MY_TERM_EDITOR='vim'
export MY_GUI_EDITOR='/opt/sublime_text/sublime_text'
export MY_FILE_MANAGER='pcmanfm'
export MY_DATE_FORMAT='%Y-%m-%d'

# the tested build of sublime text
export MY_SUBLIME='sublime-text_build-3114_amd64.deb'

# color escape seqs for printf / echo
export BLACK='\033[0;30m'
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export BROWN='\033[0;33m'
export ORANGE=$BROWN
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT_GRAY='\033[0;37m'
export DARK_GRAY='\033[1;30m'
export LIGHT_RED='\033[1;31m'
export LIGHT_GREEN='\033[1;32m'
export YELLOW='\033[1;33m'
export LIGHT_BLUE='\033[1;34m'
export LIGHT_PURPLE='\033[1;35m'
export LIGHT_CYAN='\033[1;36m'
export WHITE='\033[1;37m'
export NO_COLOR='\033[0m'

###############################################################################
# aliases
###############################################################################

# shorthand to pull alias file into caller's terminal (rs ~= "re-source")
alias rs='source ~/.bash_aliases && echo "bash aliases refreshed" || echo "error in bash aliases file"'

# default terminal emulator
alias term='`$MY_TERM`'
alias sterm='`$MY_TERM --command="sudo -s"`'

# default editors (change these to your favorites)
alias term-editor='`$MY_TERM_EDITOR`'
alias gui-editor='`$MY_GUI_EDITOR`'

# default file manager
alias file-manager='`$MY_FILE_MANAGER`'

# system state
alias headers='linux-headers-$(uname -r)'
alias shutdown='shutdown -h now'
alias reboot='sudo reboot'

# better default behaviors for standard utils
alias rm='rm --one-file-system --preserve-root'
alias date='date +$MY_DATE_FORMAT'
alias ls='ls -AhlsX --color=always'
alias lss='ls --sort=size'
alias less='less -R'

alias del='trash-put'
alias sdel='sudo trash-put'

# package management
alias deps='headers ssh vim apt-file trash-cli filezilla wireshark dkms build-essential linux-headers-generic'
alias list='dpkg --list'
alias list-kernels='list | grep linux-image-'
alias list-headers='list | grep linux-headers-'

# dpkg install/uninstall shorthands
alias dinstall='sudo dpkg -i'
alias dreinstall='sudo dpkf -r'
alias install='sudo apt-get -y install'
alias reinstall='install --reinstall'
alias uninstall='sudo apt-get remove'

# remove old linux kernel versions
alias autoremove='sudo apt-get autoremove'
alias purge='sudo apt-get -y purge'
alias purge-kernels='list | grep linux-image | cut -d " " -f 3 | sort -V | sed -n "/"`uname -r`"/q;p" | xargs sudo apt-get purge'
alias purge-configs='dpkg -l | grep "^rc" | cut -d " " -f 3 | xargs sudo apt-get purge'

# pull latest bashrc from server or restore prev
alias bashrc-down='(cp -f ~/.bak/.bashrc ~/ && success "bashrc downgrade") || fail "bashrc downgrade"'
alias bashrc-up='push ~ ; \
  del .bak/.bashrc ; \
  cp -f .bashrc .bak/ ; \
  wget --timestamping --show-progress --progress=dot --timeout=5 http://raw.githubusercontent.com/entangledloops/config/master/linux/.bashrc && \
  success "bashrc upgrade" || (fail "bashrc upgrade" ; bashrc-down) ; \
  pop'

# pull latest vimrc from server or restore prev (this file)
alias alias-down='(cp -f ~/.bak/.bash_aliases ~/ ; source ~/.bash_aliases && success "alias downgrade") || fail "alias downgrade"'
alias alias-up='push ~ ; \
  del .bak/.bash_aliases ; \
  cp -f .bash_aliases .bak/ ; \
  ( \
    wget --timestamping --show-progress --progress=dot --timeout=5 http://raw.githubusercontent.com/entangledloops/config/master/linux/.bash_aliases && \
    source .bash_aliases ; \
    success "alias upgrade"
  ) || \
  (fail "alias upgrade" ; alias-down) ; \
  pop'

# pull latest vimrc from server or restore prev
alias vimrc-down='(cp -f ~/.bak/.vimrc ~/ && success "vimrc downgrade") || fail "vimrc downgrade"'
alias vimrc-up='push ~ ; \
  del .bak/.vimrc ; \
  cp -f .vimrc .bak/ ; \
  wget --timestamping --show-progress --progress=dot --timeout=5 http://raw.githubusercontent.com/entangledloops/config/master/linux/.vimrc && \
  success "vimrc upgrade" || (fail "vimrc upgrade" ; vimrc-down) ; \
  pop'

# pull latest vimrc and vim settings folder from server or restore prev
alias vim-down='del ~/.vim >/dev/null 2&>1 ; cp -rf ~/.bak/.vim ~/ ; (vimrc-down && success "vim downgrade") || fail "vim downgrade"'
alias vim-up='vimrc-up && \
  ( \
    push ~ ;\
    echo "backing up vim settings..." ; \
    del .bak/.vim >/dev/null 2>&1 ; \
    cp -rf .vim .bak/ ; \
    echo "syncing with latest vim settings..." ; \
    del entangledloops.com >/dev/null 2>&1 ; \
    wget --reject="index.html" -e robots=off -r --show-progress --progress=dot --timestamping --timeout=5 --no-parent http://raw.githubusercontent.com/entangledloops/config/master/linux/.vim/ && \
    rsync -r -u -v -t --delay-updates --itemize-changes --stats entangledloops.com/files/config/linux/.vim/ .vim && 
    rm -rf entangledloops.com ; \
    success "vim upgrade" || (fail "vim upgrade" ; vim-down) ; \
    pop \
  )'

# component update helpers
alias os-upgrade='sudo do-release-upgrade -d'
alias os-up='os-upgrade'
alias gui-update='sudo update-manager -d'
alias gupd='gui-update'
alias update='sudo apt-get update'
alias upd='rs && update  && success "update" || fail "update"'
alias upgrade='sudo apt-get upgrade -y'
alias upg='upgrade && success "upgrade" || fail "upgrade"'
alias config-up='bashrc-up && alias-up && vim-up'
alias dist-upgrade='sudo apt-get dist-upgrade -y'
alias dist-up='(dist-upgrade && apt-file update && config-up && success "dist upgrade") || fail "dist upgrade"'

# update/upgrade flavors
alias u='upd && upg'
alias uu='upd && dist-upgrade && u'
alias uuu='upd && dist-up && u'

# version / system info
alias inodes='df -ih'
alias kernelversion='uname -r'
alias osversion='lsb_release -a'
alias version="echo $'kernel:\n\t$(kernelversion)\nos:\n\t$(osversion | awk -vRS="\n" -vORS="\n\t" '1')'"
alias diskinfo="echo $'inodes:\n$(inodes | awk -vRS="\n" -vORS="\n\t" '1')\n\ndisk:\n$(df | awk -vRS="\n" -vORS="\n\t" '1')'"
alias info="echo $'$(diskinfo)\n$(version)'"

# locate hd memory sinks
alias space='du -h --max-depth=1 | sort -hr | less'

# clear scrollback and recent output; annoying leading newline still printed
alias cls='clear && echo -e \\033c'

# shorthand for my favorite console editor
alias svim='sudo vim'
alias vimrc='vim ~/.vimrc'
alias vima='vim ~/.bash_aliases && rs'
alias vimscreenrc='vim ~/.screenrc'
alias vimbashrc='vim ~/.bashrc'

# console editing; replace 'term-editor' target w/your favorite editor
alias edit='term-editor'
alias sedit='sudo term-editor'
alias edita='term-editor ~/.bash_aliases && rs'

# gui editing; replace w/your facorite editor
alias guiedit='gui-editor'
alias sguiedit='sudo gui-editor'
alias guiedita='gui-editor ~/.bash_aliases && rs'

# personal preference for quick access to frequently modified files
alias v='vimrc'
alias a='vima'
alias s='vimscreenrc'
alias b='vimbashrc'
alias e='edit'
alias g='guiedit'

###############################################################################
# functions
###############################################################################

# shorthand to launch and detach a process supressing all output
function bg_helper() { (nohup $@ >/dev/null 2>&1 & disown) >/dev/null; }
alias bg='bg_helper'

# generic file open; replace w/whatever you want (hex editor, etc.)
function open_helper() { bg "$MY_FILE_MANAGER $@"; }
alias open='open_helper'
alias sopen='sudo open'

# find from pwd; don't forget double-quotes, e.g.: find "*.txt"
function find_helper() { /usr/bin/find . -iname "$@" -readable -writable -prune -print; }
alias find='find_helper'

# find from root; don't forget double-quotes, e.g.: findall "*.txt"
function findall_helper() { /usr/bin/find / -iname "$@" 2>&1 | grep -v 'Permission denied' >&2; }
alias findall='findall_helper'

# greps the full package list for targets matching provided grep string
function listgrep() { /usr/bin/dpkg -l | grep "$@"; }

# OpenSSH -> SSH2 helper
function openssh_to_ssh2_helper() { ssh-keygen -e -f $@ > $@.ssh2; }
alias openssh-to-ssh2='openssh_to_ssh2_helper'

# SSH2 -> OpenSSH
function ssh2_to_openssh_helper() { ssh-keygen -i -f $@ > $@.openssh; }
alias ssh2-to-openssh='ssh2_to_openssh_helper'

# GNU screen integration
function screen_helper() { if [ -z "$STY" ]; then screen -RR -A -r "$@" || screen; fi; }
alias screen='screen_helper'

function pkg_helper() { sudo dpkg --search $@ >/dev/null 2>&1; if [ $? != 0 ]; then fail "unable to locate on local machine, searching repositories..."; apt-file search $@; fi; }
alias pkg='pkg_helper'

function push_helper() { pushd $@ >/dev/null 2>&1 ; }
alias push='push_helper'

function pop_helper() { popd $@ >/dev/null 2>&1 ; }
alias pop='pop_helper'

alias cd='push'

function success_helper() { printf "I ${GREEN}$@ successful${NO_COLOR}\n" ; }
alias success='success_helper'

function fail_helper() { printf "I ${RED}$@ failed${NO_COLOR}\n" ; }
alias fail='fail_helper'

###############################################################################
# apps to launch in background
###############################################################################

alias filezilla='bg "filezilla"'
alias wireshark='bg "sudo wireshark"'


# helper for sublime text which isn't in a repo currently
alias install-sublime='push /tmp ; \
  wget --show-progress --progress=dot https://download.sublimetext.com/$MY_SUBLIME && \
  dinstall $MY_SUBLIME && \
  rm -f $MY_SUBLIME >/dev/null 2>&1 ; \
  pop'

###############################################################################
# env
###############################################################################

# include pwd in path
export PATH=$PATH:.

###############################################################################
# custom (NOTE: edits beyond here will be preserved during an alias-up)
###############################################################################
