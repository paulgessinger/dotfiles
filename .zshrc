if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


# Returns whether the given command is executable or aliased.
_has() {
  return $( whence $1 >/dev/null )
}

_append_to_path() {
  if [ -d $1 -a -z ${path[(r)$1]} ]; then
    path=($1 $path);
  fi
}



# fzf via Homebrew
if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
source /usr/local/opt/fzf/shell/key-bindings.zsh
source /usr/local/opt/fzf/shell/completion.zsh
fi

# fzf via local installation
if [ -e ~/.fzf ]; then
_append_to_path ~/.fzf/bin
source ~/.fzf/shell/key-bindings.zsh
source ~/.fzf/shell/completion.zsh
fi

# fzf + ag configuration
if _has fzf && _has ag; then
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
fi


if [ -f ~/.bash_profile ]; then
        . ~/.bash_profile
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

precmd() { eval "$PROMPT_COMMAND" }
shrink_path () {
  setopt localoptions
  setopt rc_quotes null_glob

  typeset -i lastfull=0
  typeset -i short=0
  typeset -i tilde=0
  typeset -i named=0

  if zstyle -t ':prompt:shrink_path' fish; then
    lastfull=1
    short=1
    tilde=1
  fi
  if zstyle -t ':prompt:shrink_path' nameddirs; then
    tilde=1
    named=1
  fi
  zstyle -t ':prompt:shrink_path' last && lastfull=1
  zstyle -t ':prompt:shrink_path' short && short=1
  zstyle -t ':prompt:shrink_path' tilde && tilde=1

  while [[ $1 == -* ]]; do
    case $1 in
      -f|--fish)
        lastfull=1
        short=1
        tilde=1
        ;;
      -h|--help)
        print 'Usage: shrink_path [-f -l -s -t] [directory]'
        print ' -f, --fish      fish-simulation, like -l -s -t'
        print ' -l, --last      Print the last directory''s full name'
        print ' -s, --short     Truncate directory names to the first character'
        print ' -t, --tilde     Substitute ~ for the home directory'
        print ' -T, --nameddirs Substitute named directories as well'
        print 'The long options can also be set via zstyle, like'
        print '  zstyle :prompt:shrink_path fish yes'
        return 0
        ;;
      -l|--last) lastfull=1 ;;
      -s|--short) short=1 ;;
      -t|--tilde) tilde=1 ;;
      -T|--nameddirs)
        tilde=1
        named=1
        ;;
    esac
    shift
  done

  typeset -a tree expn
  typeset result part dir=${1-$PWD}
  typeset -i i

  [[ -d $dir ]] || return 0

  if (( named )) {
    for part in ${(k)nameddirs}; {
      [[ $dir == ${nameddirs[$part]}(/*|) ]] && dir=${dir/#${nameddirs[$part]}/\~$part}
    }
  }
  (( tilde )) && dir=${dir/#$HOME/\~}
  tree=(${(s:/:)dir})
  (
  if [[ $tree[1] == \~* ]] {
    cd -q ${~tree[1]}
    result=$tree[1]
    shift tree
  } else {
  cd -q /
}
for dir in $tree; {
  if (( lastfull && $#tree == 1 )) {
    result+="/$tree"
    break
  }
  expn=(a b)
  part=''
  i=0
  until [[ (( ${#expn} == 1 )) || $dir = $expn || $i -gt 99 ]]  do
    (( i++ ))
    part+=$dir[$i]
    expn=($(echo ${part}*(-/)))
    (( short )) && break
  done
  result+="/$part"
  cd -q $dir
  shift tree
}
echo ${result:-/}
)
}
