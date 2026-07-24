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
  eval $(/opt/homebrew/bin/brew shellenv)
  source $(brew --prefix antidote)/share/antidote/antidote.zsh

elif [[ $(uname) == "Linux" ]]; then
  source ~/.antidote/antidote.zsh
  alias ls='ls --color -h'
fi

alias lg="lazygit"


antidote load

if [[ -f ~/.fzf/bin/fzf ]]; then
  export PATH=~/.fzf/bin:$PATH
fi 

source <(fzf --zsh)

if [[ -d ~/spack ]]; then
  source ~/spack/share/spack/setup-env.sh
fi


zstyle ':completion:*' menu select

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[3~" delete-char

eval "$(starship init zsh)"

# Don't call `autoload -Uz compinit; compinit` here: that replaces use-omz's compinit
# wrapper with the real one, so its compdef queue is never replayed. use-omz runs
# compinit itself at the first prompt -- fpath just has to be complete by then.
fpath+=~/.zfunc

if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi
# Lima BEGIN
# Make sure iptables and mount.fuse3 are available
PATH="$PATH:/usr/sbin:/sbin"
export PATH
# Lima END

function theme_set {
  echo "Setting theme to $1"
  tmux set-environment THEME $1
  tmux source-file ~/.tmux.conf
}
export theme_set

alias set_theme_light="theme_set light"
alias set_theme_dark="theme_set dark"

# --- git worktree helper -----------------------------------------------
wt() {
  local root dir
  local -a ref
  if [[ -z $1 ]]; then
    print -u2 "usage: wt <branch|commit-ish>"
    return 2
  fi

  local common
  common=$(git rev-parse --path-format=absolute --git-common-dir) || return
  root=${common%/.git}
  dir="$root/.worktrees/${1//\//-}"     # keep the namespace: feature/foo -> feature-foo

  if [[ -d $dir ]]; then
    cd "$dir"
    return
  fi

  if git show-ref --verify --quiet "refs/heads/$1"; then
    ref=("$1")                          # local branch
  elif git show-ref --verify --quiet "refs/remotes/origin/$1"; then
    ref=(-b "$1" --track "origin/$1")   # remote-only
  elif git rev-parse --verify --quiet "$1^{commit}" >/dev/null; then
    ref=("$1")                          # tag / SHA / other commit-ish
  else
    ref=(-b "$1")                       # nothing matched: new branch off HEAD
  fi

  # keep .worktrees out of git status (local only, never committed)
  grep -qxF '/.worktrees/' "$root/.git/info/exclude" 2>/dev/null ||
    print '/.worktrees/' >> "$root/.git/info/exclude"

  git worktree add "$dir" "${ref[@]}" && cd "$dir"
}

# Completion lives in ~/.zfunc/_wt, tagged `#compdef wt`. compinit rediscovers it on
# every run, so it doesn't depend on a plugin replaying a compdef queue.
# -----------------------------------------------------------------------
