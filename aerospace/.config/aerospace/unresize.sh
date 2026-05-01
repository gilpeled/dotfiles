#!/usr/bin/env bash
if ! aerospace list-windows --workspace focused --format '%{window-id}' | ~/.local/bin/winbounds; then
  aerospace resize "$@"
fi
