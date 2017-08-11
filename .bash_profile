if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
        platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
      platform='freebsd'
fi


###
# VARIABLES
###

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

###
# LS COLORS
###
if [[ $platform == 'linux' ]]; then
        alias ls='ls --color -h'
elif [[ $platform == 'freebsd' ]]; then
      alias ls='ls -G -h'
fi


###
# ALIASES AND FUNCTIONS
###

alias ll="ls -l"
#alias mk="make -j8 ; tput bel"
#alias mk1="make -j1 ; tput bel"

function mk {
  make $1 -j8 ; tput bel
}
export mk

function bld {
  if [ -f ../build.sh ]; then
    bf="../build.sh"
  elif [ -f ./build.sh ]; then
    bf="./build.sh"
  else
    echo "build.sh not found"
    return 1
  fi
  
  eval $bf
}
export bld

function cfg {
  if [ -f ../config.sh ]; then
    cf="../config.sh"
  elif [ -f ./config.sh ]; then
    cf="./config.sh"
  else
    echo "config.sh not found"
    return 1
  fi
  
  eval $cf
}
export cfg

function cmk {
  cmake --build . -- -j8 ; tput bel
}
export cmk

function setupMogon {
  if mount | grep ~/mogon/home > /dev/null; then
      echo "mogon home dir already mounted"
  else
      echo "mounting mogon home dir"
      sshfs mogon:/gpfs/fs1/home/pgessing/ ~/mogon/home -o follow_symlinks -o auto_cache
      export MOGONDIR=~/mogon/home
  fi
}
export setupMogon

function setupRMogon {
  if mount | grep ~/mogon/home > /dev/null; then
      echo "mogon home dir already mounted"
  else
      echo "mounting mogon home dir"
      sshfs rmogon:/gpfs/fs1/home/pgessing/ ~/mogon/home -o follow_symlinks -o cache=no
      export MOGONDIR=~/mogon/home
  fi
}
export setupRMogon

function skim {
  open -a Skim $1
}
export skim

function tower {
  open -a Tower $1
}
export tower

alias vi="vim"

###
# SETUP DEFAULT ROOT
###
#CURRENT=$(pwd)
#cd /Users/Paul/root && source /Users/Paul/root/bin/thisroot.sh
#cd $CURRENT


if [ -n "$BASH_VERSION" ]; then
        test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi

