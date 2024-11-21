export LC_ALL=en_US.UTF-8


export EDITOR="nvim"
export LSCOLORS=GxFxCxDxBxegedabagaced
export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

export PATH=~/.local/bin:$PATH
export PATH=~/.local/$HOSTNAME/bin:$PATH

export PATH=~/.cargo/bin:$PATH

if [[ $(uname) == "Darwin" ]]; then
  alias ls='ls -G -h'
  source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
elif [[ $(uname) == "Linux" ]]; then
  source ~/.antidote/antidote.zsh
  alias ls='ls --color -h'
fi

alias lg="lazygit"


antidote load


if [[ -f ~/.fzf/bin/fzf ]]; then
  export PATH=~/.fzf/bin:$PATH
  source <(fzf --zsh)
fi 

if [[ -d ~/spack ]]; then
  source ~/spack/share/spack/setup-env.sh
fi

# Available completion styles: gremlin, ohmy, prez, zshzoo
# You can add your own too. To see all available completion styles
# run 'compstyle -l'
zstyle ':plugin:ez-compinit' 'compstyle' 'ohmy'

zstyle ':completion:*' menu select

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line

eval "$(starship init zsh)"

fpath+=~/.zfunc; autoload -Uz compinit; compinit
