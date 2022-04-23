#!/bin/bash -e

session="server"

tmux new-session -d -s $session

window=0
tmux rename-window  -t $session:$window $session
tmux split-window   -t $session:$window -bl 8
tmux send-keys      -t $session:$window 'cerberusd start' C-m
tmux split-window   -t $session:$window -hl 50
tmux send-keys      -t $session:$window 'watch -n 30 ./tstatus.sh' C-m
tmux select-pane    -t $session:$window -D

#tmux attach-session -s node -t $session
