#!/bin/bash
# Set up dotfiles: packages, symlinks, plugins. Safe to re-run.
#   ./install.sh               full setup
#   ./install.sh --no-packages only symlinks + plugins
set -euo pipefail

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_PACKAGES=1
[[ "${1:-}" == "--no-packages" ]] && INSTALL_PACKAGES=0

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

# link <source in dotfiles> <target>: back up anything that isn't already our symlink.
link() {
  local src="$DOTFILES/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -L "$dst" && "$(readlink "$dst")" -ef "$src" ]]; then
    return
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    log "backing up $dst -> $dst.orig"
    mv "$dst" "$dst.orig"
  fi
  ln -s "$src" "$dst"
  log "linked $dst"
}

clone() {  # clone <url> <dir> [git clone args...]
  local url="$1" dir="$2"; shift 2
  [[ -d "$dir" ]] && return
  git clone --depth 1 "$@" "$url" "$dir"
}

# ask <question>: y/N prompt; answers no when there's no terminal to ask on.
ask() {
  local reply
  [[ -t 0 ]] || { log "skipping (non-interactive): $1"; return 1; }
  read -r -p "$1 [y/N] " reply
  [[ "$reply" == [yY]* ]]
}

# latest_tag <owner/repo>: tag name of the latest GitHub release.
latest_tag() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" |
    sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p'
}

# Static binaries from GitHub releases, so no root is needed.
install_lazygit() {
  local tag arch tmp
  tag=$(latest_tag jesseduffield/lazygit)
  case "$(uname -m)" in
    x86_64) arch=x86_64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) log "lazygit: unsupported arch $(uname -m)"; return ;;
  esac
  tmp=$(mktemp -d)
  curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/$tag/lazygit_${tag#v}_Linux_$arch.tar.gz" |
    tar -xz -C "$tmp" lazygit
  mkdir -p ~/.local/bin
  mv "$tmp/lazygit" ~/.local/bin/
  rm -rf "$tmp"
  log "installed lazygit $tag"
}

install_delta() {
  local tag target tmp
  tag=$(latest_tag dandavison/delta)
  case "$(uname -m)" in
    x86_64) target=x86_64-unknown-linux-musl ;;
    aarch64|arm64) target=aarch64-unknown-linux-gnu ;;
    *) log "delta: unsupported arch $(uname -m)"; return ;;
  esac
  tmp=$(mktemp -d)
  curl -fsSL "https://github.com/dandavison/delta/releases/download/$tag/delta-$tag-$target.tar.gz" |
    tar -xz -C "$tmp" --strip-components 1
  mkdir -p ~/.local/bin
  mv "$tmp/delta" ~/.local/bin/
  rm -rf "$tmp"
  log "installed delta $tag"
}

# --- packages -------------------------------------------------------------
if (( INSTALL_PACKAGES )); then
  if [[ "$OSTYPE" == darwin* ]]; then
    if ! command -v brew >/dev/null && [[ ! -x /opt/homebrew/bin/brew ]]; then
      log "installing homebrew"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    eval "$(/opt/homebrew/bin/brew shellenv)"
    log "installing brew packages"
    brew install \
      antidote starship fzf tmux neovim node tree-sitter-cli \
      git-delta lazygit jj jjui gh tig \
      ripgrep fd bat just uv wget
    brew install --cask ghostty font-jetbrains-mono-nerd-font
  else
    log "linux: user-local installs (install neovim, tmux, jj yourself)"
    clone https://github.com/mattmc3/antidote.git ~/.antidote
    if [[ ! -d ~/.fzf ]]; then
      clone https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install --bin
    fi
    if ! command -v starship >/dev/null; then
      mkdir -p ~/.local/bin
      curl -sS https://starship.rs/install.sh | sh -s -- -y -b ~/.local/bin
    fi
    if ! command -v lazygit >/dev/null && ask "install lazygit to ~/.local/bin?"; then
      install_lazygit
    fi
    if ! command -v delta >/dev/null && ask "install delta (lazygit/git diff pager) to ~/.local/bin?"; then
      install_delta
    fi
  fi
fi

# --- shell ----------------------------------------------------------------
link .zshrc            ~/.zshrc
link .zsh_plugins.txt  ~/.zsh_plugins.txt
link zfunc/_wt         ~/.zfunc/_wt
link zfunc/_jw         ~/.zfunc/_jw
link starship.toml     ~/.config/starship.toml
link .bashrc.base      ~/.bashrc
link .bash_profile     ~/.bash_profile

# bash only: .bashrc.base sources these from ~
for f in git-completion.bash git-prompt.sh; do
  [[ -f ~/$f ]] || curl -fsSL -o ~/$f "https://raw.githubusercontent.com/git/git/master/contrib/completion/$f"
done

# --- editor ---------------------------------------------------------------
link nvim   ~/.config/nvim
link .vimrc ~/.vimrc
mkdir -p ~/.vim/backup ~/.vim/swp

# --- terminal / tmux ------------------------------------------------------
link ghostty    ~/.config/ghostty
link .tmux.conf ~/.tmux.conf
clone https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux --branch v2.1.3

# --- git ------------------------------------------------------------------
link .gitconfig ~/.gitconfig
if [[ "$OSTYPE" == darwin* ]]; then
  link lazygit.yml ~/Library/Application\ Support/lazygit/config.yml
else
  link lazygit.yml ~/.config/lazygit/config.yml
fi

link Justfile ~/Justfile

# --- post-install ---------------------------------------------------------
if command -v nvim >/dev/null; then
  log "restoring neovim plugins from lazy-lock.json"
  nvim --headless "+Lazy! restore" +qa || true
fi

if [[ "$(basename "${SHELL:-}")" != zsh ]] && command -v zsh >/dev/null; then
  log "changing login shell to zsh"
  chsh -s "$(command -v zsh)" || true
fi

log "done — open a new shell (antidote fetches zsh plugins on first start)"
