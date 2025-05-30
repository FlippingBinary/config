#!/usr/bin/env sh

# set PATH so it includes user's bob bin if it exists
if [ -d "$HOME/.local/share/bob/nvim-bin" ] ; then
  PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
fi

