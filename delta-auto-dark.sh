#!/bin/bash

# THEME comes from tmux (set by theme_set). Outside tmux, keep any THEME already in
# the environment, else follow the macOS appearance, else assume light.
if [ -n "$TMUX" ]; then
  eval "$(tmux show-environment THEME 2>/dev/null)"
fi
if [ -z "$THEME" ] && [[ "$OSTYPE" == darwin* ]]; then
  if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
    THEME=dark
  fi
fi

if [ "$THEME" = "dark" ]; then
  export DELTA_FEATURES=weeping-willow
else
  export DELTA_FEATURES=mellow-barbet
fi
exec delta "$@"
