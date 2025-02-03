#!/usr/bin/env zsh

(( $+commands[tinty] )) || return 1

if [[ ! -f "$ZSH_CACHE_DIR/completions/_tinty" ]]; then
  typeset -g -A _comps
  autoload -Uz _tinty
  _comps[tinty]=_tinty
fi

tinty generate-completion zsh >| "$ZSH_CACHE_DIR/completions/_tinty" &|

# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------
