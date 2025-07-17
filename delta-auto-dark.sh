#!/bin/bash

eval "$(tmux show-environment THEME)"

if [ "$THEME" = "dark" ]; then
  export DELTA_FEATURES=weeping-willow
else
  export DELTA_FEATURES=mellow-barbet
fi
exec delta --paging=never "$@"
