[no-cd]
init-ws:
  ln -sf ~/dev/acts/config.sh .
  ln -sf ~/dev/acts/CMakeUserPresets.json .
  ln -sf ~/dev/acts/CLAUDE.md .
  ln -sf CLAUDE.md AGENTS.md
  ln -sf ~/dev/acts/Justfile .


tmux-work:
  tmux new-session -d -s work

  tmux new-window -t work: -n acts1 zsh
  tmux new-window -t work: -n acts2 zsh
  tmux new-window -t work: -n acts3 zsh
  tmux new-window -t work: -n acts4 zsh

  tmux kill-window -t 1

  tmux send-keys -t work:1 "cd ~/dev/acts" C-m
  tmux send-keys -t work:2 "cd ~/dev/acts2" C-m
  tmux send-keys -t work:3 "cd ~/dev/acts3" C-m
  tmux send-keys -t work:4 "cd ~/dev/acts4" C-m

[no-cd]
init-nb-kernel:
  uv venv --allow-existing
  uv pip install matplotlib numpy pandas ipykernel hist mplhep
