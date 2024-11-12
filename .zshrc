export LC_ALL=en_US.UTF-8

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh

export EDITOR="nvim"
export LSCOLORS=GxFxCxDxBxegedabagaced
export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
        platform='linux'
elif [[ "$unamestr" == 'FreeBSD' || "$unamestr" == "Darwin" ]]; then
      platform='freebsd'
fi

###
# LS COLORS
###
if [[ $platform == 'linux' ]]; then
        alias ls='ls --color -h'
elif [[ $platform == 'freebsd' ]]; then
      alias ls='ls -G -h'
fi

alias lg="lazygit"

antidote load

# Available completion styles: gremlin, ohmy, prez, zshzoo
# You can add your own too. To see all available completion styles
# run 'compstyle -l'
# zstyle ':plugin:ez-compinit' 'compstyle' 'ohmy'

zstyle ':completion:*' menu select


eval "$(starship init zsh)"
