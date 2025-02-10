#!/usr/bin/env zsh

if [[ -n "$OSTYPE" && "${(L)OSTYPE}" == *darwin* ]]; then
  export MACOSX_DEPLOYMENT_TARGET=$(sw_vers -productVersion)
fi

export DOCKER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/docker"

export GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"

export TLDR_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/tldr"

export TERMINFO="${XDG_DATA_HOME:-$HOME/.local/share}/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"

export VAGRANT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/vagrant"

export LESSHISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/less/history"

export MYSQL_HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/mysql/history"

export SQLITE_HISTORY="${XDG_STATE_HOME:-$HOME/.local/state}/sqlite/history"

env_dirs=(
  "$ENV_DIRS"
  "$DOCKER_CONFIG"
  "$TLDR_CACHE_DIR"
  "$GNUPGHOME"
  "$TERMINFO"
  "$VAGRANT_HOME"
  "$(dirname "$LESSHISTFILE")"
  "$(dirname "$MYSQL_HISTFILE")"
  "$(dirname "$SQLITE_HISTORY")"
)

env_dirs=(${(@)env_dirs:#""})
export ENV_DIRS="${(j/:/)env_dirs}"
unset env_dirs

# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------
