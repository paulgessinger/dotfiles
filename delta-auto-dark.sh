#!/bin/bash

eval "$(tmux show-environment THEME)"

if [ "$THEME" = "dark" ]; then
  exec delta --dark --paging=never "$@"
else
  exec delta --light --paging=never "$@"
fi
