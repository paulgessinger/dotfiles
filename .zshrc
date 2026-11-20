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

alias opus="claude --model opus"
alias sonnet="claude --model sonnet"
alias fable="claude --model fable"


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
  emulate -L zsh
  local common root arg branch remote dir r l cur curbranch slug i kind
  local existing existing_branch
  local -a ref remotes search matches lines wt_paths wt_branches fetch_from

  arg=$1
  if [[ -z $arg ]]; then
    print -u2 "usage: wt <branch|remote/branch|commit-ish>"
    return 2
  fi

  common=$(git rev-parse --path-format=absolute --git-common-dir) || return
  root=${common%/.git}
  remotes=(${(f)"$(git remote)"})

  # `wt origin/foo` -> remote=origin, branch=foo. Only split when the first component
  # really names a remote, so a branch actually called feature/foo still resolves.
  branch=$arg
  if [[ $arg == */* ]] && (( ${remotes[(Ie)${arg%%/*}]} )); then
    remote=${arg%%/*}
    branch=${arg#*/}
  fi

  # Index the existing worktrees by both branch and directory name, so the argument can
  # name either one -- branch feature/foo lives in a worktree called feature-foo.
  lines=(${(f)"$(git worktree list --porcelain)"})
  for l in $lines; do
    if [[ $l == 'worktree '* ]]; then
      [[ -n $cur ]] && { wt_paths+=("$cur"); wt_branches+=("$curbranch") }
      cur=${l#worktree }
      curbranch=
    elif [[ $l == 'branch refs/heads/'* ]]; then
      curbranch=${l#branch refs/heads/}
    fi
  done
  [[ -n $cur ]] && { wt_paths+=("$cur"); wt_branches+=("$curbranch") }

  slug=${branch//\//-}                     # keep the namespace: feature/foo -> feature-foo
  dir="$root/.worktrees/$slug"

  # Branch name first -- it's the more specific match.
  for (( i = 1; i <= $#wt_paths; i++ )); do
    if [[ $wt_branches[i] == "$branch" ]]; then
      existing=$wt_paths[i]; kind=branch
      break
    fi
  done
  # Then worktree directory name. Also covers detached worktrees (a tag or SHA), which
  # have no branch line at all.
  if [[ -z $existing ]]; then
    for (( i = 1; i <= $#wt_paths; i++ )); do
      if [[ ${wt_paths[i]:t} == "$slug" || ${wt_paths[i]:t} == "$arg" ]]; then
        existing=$wt_paths[i]; existing_branch=$wt_branches[i]; kind=name
        break
      fi
    done
  fi
  # Last resort: a directory that isn't a registered worktree.
  [[ -z $existing && -d $dir ]] && { existing=$dir; kind=dir }

  if [[ -n $existing ]]; then
    if [[ $existing -ef $PWD ]]; then
      if [[ $kind == branch ]]; then
        print "wt: already in the worktree for '$branch'"
      else
        print "wt: already in the worktree '${existing:t}'"
      fi
    elif [[ $kind == dir ]]; then
      print "wt: reusing existing directory $existing"
    elif [[ $kind == name && -n $existing_branch && $existing_branch != $branch ]]; then
      print "wt: worktree '${existing:t}' is on branch '$existing_branch'"
    else
      print "wt: '$branch' is already checked out at $existing"
    fi
    cd "$existing"
    return
  fi

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    # A local branch of that name wins -- don't try to re-create it from the remote.
    [[ -n $remote ]] &&
      print "wt: local branch '$branch' already exists, checking it out instead of creating it from $remote/$branch"
    ref=("$branch")
  else
    if [[ -n $remote ]]; then search=($remote); else search=($remotes); fi

    # Which remotes already have this branch?
    for r in $search; do
      git show-ref --verify --quiet "refs/remotes/$r/$branch" && matches+=($r)
    done

    # Nothing locally? It may simply be unfetched. Ask for that one ref before concluding
    # this is a new branch -- otherwise `wt their-branch` silently creates an unrelated
    # branch off HEAD instead of checking theirs out. Only ask the named remote, else
    # origin: a repo full of contributor forks would mean a round trip per remote.
    if (( ! $#matches )); then
      if [[ -n $remote ]]; then
        fetch_from=($remote)
      elif (( ${remotes[(Ie)origin]} )); then
        fetch_from=(origin)
      elif (( $#remotes == 1 )); then
        fetch_from=($remotes)
      fi
      for r in $fetch_from; do
        # NB: braces are required -- unbraced `$branch:refs/...` would be parsed as the
        # zsh `:r` modifier and silently eat the refspec's colon.
        git fetch --quiet $r "refs/heads/${branch}:refs/remotes/${r}/${branch}" 2>/dev/null &&
          matches+=($r)
      done
    fi

    # Prefer origin when several remotes carry the same branch name.
    if (( $#matches > 1 )); then
      if (( ${matches[(Ie)origin]} )); then
        matches=(origin)
      else
        print -u2 "wt: '$branch' exists on multiple remotes: $matches"
        print -u2 "    disambiguate with: wt <remote>/$branch"
        return 1
      fi
    fi

    if (( $#matches )); then
      ref=(-b "$branch" --track "$matches[1]/$branch")  # remote branch -> tracking branch
    elif [[ -n $remote ]]; then
      print -u2 "wt: '$branch' not found on remote '$remote'"
      return 1
    elif git rev-parse --verify --quiet "$arg^{commit}" >/dev/null; then
      ref=("$arg")                                     # tag / SHA / other commit-ish
    else
      ref=(-b "$branch")                               # nothing matched: new branch off HEAD
    fi
  fi

  # keep .worktrees out of git status (local only, never committed)
  grep -qxF '/.worktrees/' "$common/info/exclude" 2>/dev/null ||
    print '/.worktrees/' >> "$common/info/exclude"

  git worktree add "$dir" "${ref[@]}" && cd "$dir"
}

# Completion lives in ~/.zfunc/_wt, tagged `#compdef wt`. compinit rediscovers it on
# every run, so it doesn't depend on a plugin replaying a compdef queue.
# -----------------------------------------------------------------------

# --- jj workspace helper (the wt equivalent) ---------------------------
jw() {
  emulate -L zsh
  local arg wsroot root repodir name remote slug dir rev r
  local -a names local_bms remote_bms matches addargs

  arg=$1
  if [[ -z $arg ]]; then
    print -u2 "usage: jw <bookmark|bookmark@remote|revision|workspace>"
    return 2
  fi

  wsroot=$(jj workspace root 2>/dev/null) || return
  # The default workspace holds .jj/repo as a directory; a secondary workspace holds a
  # .jj/repo *file* containing a relative path back to it.
  if [[ -d $wsroot/.jj/repo ]]; then
    root=$wsroot
  else
    repodir=$wsroot/.jj/$(<$wsroot/.jj/repo)
    root=${${repodir:a}:h:h}
  fi

  # `jw foo@origin` -> name=foo, remote=origin. Bare `@` and `@-` are revsets, not splits.
  name=$arg
  if [[ $arg == ?*@?* ]]; then
    name=${arg%@*}
    remote=${arg##*@}
  fi

  slug=${name//\//-}                       # keep the namespace: feature/foo -> feature-foo
  dir="$root/.worktrees/$slug"
  names=(${(f)"$(jj workspace list -T 'name ++ "\n"' 2>/dev/null)"})

  # Already exists? jj exposes workspace names but not their paths (only an internal
  # protobuf knows those), so this relies on the .worktrees/<name> layout jw creates.
  if (( ${names[(Ie)$slug]} )); then
    if [[ ! -d $dir ]]; then
      print -u2 "jw: workspace '$slug' exists but is not at $dir"
      print -u2 "    jj does not expose workspace paths, so jw only finds ones it created"
      return 1
    fi
    if [[ $dir -ef $PWD ]]; then
      print "jw: already in workspace '$slug'"
    else
      print "jw: workspace '$slug' is at $dir"
    fi
    cd "$dir"
    return
  fi

  # What should the new workspace be based on?
  local_bms=(${(f)"$(jj bookmark list -T 'name ++ "\n"' 2>/dev/null)"})
  if [[ -z $remote ]] && (( ${local_bms[(Ie)$name]} )); then
    rev=$name                              # local bookmark
  else
    remote_bms=(${(f)"$(jj bookmark list --all-remotes -T 'if(remote, name ++ "@" ++ remote ++ "\n")' 2>/dev/null)"})
    for r in $remote_bms; do
      [[ $r == "$name@"* ]] || continue
      [[ ${r##*@} == git ]] && continue    # the colocated git backend, not a real remote
      [[ -n $remote && ${r##*@} != $remote ]] && continue
      matches+=(${r##*@})
    done

    # Prefer origin when several remotes carry the same bookmark.
    if (( $#matches > 1 )); then
      if (( ${matches[(Ie)origin]} )); then
        matches=(origin)
      else
        print -u2 "jw: '$name' exists on multiple remotes: $matches"
        print -u2 "    disambiguate with: jw $name@<remote>"
        return 1
      fi
    fi

    if (( $#matches )); then
      # Track it, so there's a local bookmark to move and push, as git's --track gives.
      jj bookmark track "$name@$matches[1]" || return
      rev=$name
    elif [[ -n $remote ]]; then
      print -u2 "jw: '$name' not found on remote '$remote'"
      return 1
    elif jj log -r "$arg" --no-graph -T '""' >/dev/null 2>&1; then
      rev=$arg                             # change id, commit id, or any other revset
    fi
    # else: nothing resolved -- a brand new workspace on a fresh change (see below)
  fi

  addargs=(--name "$slug")
  # With -r the new working copy is a child of that revision (like `jj new <rev>`);
  # without it, a sibling of the current working copy.
  [[ -n $rev ]] && addargs+=(-r "$rev")

  mkdir -p "$root/.worktrees" || return
  # jj ignores nested workspaces by itself, but a colocated repo's git half would not.
  if [[ -d $root/.git ]]; then
    grep -qxF '/.worktrees/' "$root/.git/info/exclude" 2>/dev/null ||
      print '/.worktrees/' >> "$root/.git/info/exclude"
  fi

  jj workspace add "${addargs[@]}" "$dir" && cd "$dir"
}

# Completion lives in ~/.zfunc/_jw, tagged `#compdef jw`.
# -----------------------------------------------------------------------

# --- ATLAS setup ---------------------------------------------------------
export ATLAS_LOCAL_ROOT_BASE=${ATLAS_LOCAL_ROOT_BASE:-/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase}

setupATLAS() {
  local base=$ATLAS_LOCAL_ROOT_BASE
  local setup=$base/user/atlasLocalSetup.sh
  local repo=${${base#/cvmfs/}%%/*}   # e.g. atlas.cern.ch

  if [[ ! -d /cvmfs ]]; then
    print -u2 "setupATLAS: /cvmfs does not exist -- CVMFS is not installed on this machine."
    if [[ $(uname) == Darwin ]]; then
      print -u2 "  install: https://cvmfs.readthedocs.io/en/stable/cpt-quickstart.html#mac-os-x"
    else
      print -u2 "  install the cvmfs package, then run: sudo cvmfs_config setup"
    fi
    return 1
  fi

  # autofs mounts the repo on first access; this test triggers that.
  if [[ ! -d /cvmfs/$repo ]]; then
    print -u2 "setupATLAS: /cvmfs exists but /cvmfs/$repo is not mounted."
    if (( $+commands[cvmfs_config] )); then
      print -u2 "  diagnose: cvmfs_config probe $repo"
      print -u2 "  check:    CVMFS_REPOSITORIES in /etc/cvmfs/default.local includes $repo"
    fi
    if [[ $(uname) == Darwin ]]; then
      print -u2 "  macOS has no autofs for cvmfs: sudo mount -t cvmfs $repo /cvmfs/$repo"
    else
      print -u2 "  is autofs running? systemctl status autofs"
    fi
    return 1
  fi

  if [[ ! -r $setup ]]; then
    print -u2 "setupATLAS: $repo is mounted, but $setup is missing."
    print -u2 "  is ATLAS_LOCAL_ROOT_BASE right? (currently: $base)"
    return 1
  fi

  source "$setup" "$@"
}
# -----------------------------------------------------------------------
