#!/usr/bin/env zsh

(( $+commands[fzf] )) || return 1
source <(fzf --zsh)

# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
#
