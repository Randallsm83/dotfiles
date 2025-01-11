#!/usr/bin/env zsh

(( $+commands[mise] )) || return 1

export MISE_CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export MISE_RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"

eval "$(mise activate zsh)"

# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------
