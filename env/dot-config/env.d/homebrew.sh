#!/usr/bin/env bash

# This is NOT the typical brew.env mentioned in their docs, that file doesn't support shell expansion...
# This is sourced to make things work better as expected

if [[ $(uname) == 'Darwin' ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
elif [[ $(uname) == 'Linux' ]]; then
  export HOMEBREW_PREFIX="$LOCALDIR/homebrew"
fi
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"

export HOMEBREW_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/Homebrew"
export HOMEBREW_BUNDLE_USER_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/Homebrew"
export HOMEBREW_LOGS="${XDG_CACHE_HOME:-$HOME/.cache}/Homebrew/Logs"
export HOMEBREW_TEMP="${XDG_RUNTIME_DIR:-/tmp}/Homebrew"
export HOMEBREW_OPT="$HOMEBREW_PREFIX/opt"

export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
export PATH="$HOMEBREW_OPT/curl/bin:$PATH"
export PATH="$HOMEBREW_OPT/ruby/bin:$PATH"
export PATH="$HOMEBREW_OPT/ncurses/bin:$PATH"
export PATH="$HOMEBREW_OPT/glibc/bin:$PATH"
export PATH="$HOMEBREW_OPT/glibc/sbin:$PATH"
export PATH="$HOMEBREW_OPT/make/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_OPT/gawk/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_OPT/grep/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_OPT/gnu-sed/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_OPT/gnu-tar/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_OPT/coreutils/libexec/gnubin:$PATH"
export PATH="$HOMEBREW_OPT/findutils/libexec/gnubin:$PATH"

export LD_LIBRARY_PATH="$HOMEBREW_PREFIX/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$HOMEBREW_OPT/curl/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$HOMEBREW_OPT/ruby/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$HOMEBREW_OPT/ncurses/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$HOMEBREW_OPT/readline/lib:$LD_LIBRARY_PATH"

export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/lib/pkgconfig/:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="$HOMEBREW_OPT/curl/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="$HOMEBREW_OPT/ruby/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="$HOMEBREW_OPT/ncurses/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="$HOMEBREW_OPT/readline/lib/pkgconfig:$PKG_CONFIG_PATH"

export MANPATH="$HOMEBREW_PREFIX/share/man:$MANPATH"
export INFOPATH="$HOMEBREW_PREFIX/share/info:$INFOPATH"

# Performance optimizations
cores=
if [[ $(uname) == 'Darwin' ]]; then
  cores="$(sysctl -n hw.logicalcpu)"
elif [[ $(uname) == 'Linux' ]]; then
  cores="$(nproc)"
fi

export HOMEBREW_MAKE_JOBS="$cores"
export HOMEBREW_DISPLAY_INSTALL_TIMES=1
export HOMEBREW_COLOR=1

# Security and download optimizations
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CURL_RETRIES=3

# Privacy
export HOMEBREW_NO_ANALYTICS=1

# Set default editor for Homebrew commands
export HOMEBREW_EDITOR="nvim"

# Always use Homebrew installed apps if available
export HOMEBREW_FORCE_BREWED_GIT=1
export HOMEBREW_FORCE_BREWED_CURL=1
export HOMEBREW_FORCE_VENDOR_RUBY=1
export HOMEBREW_FORCE_BREWED_CA_CERTIFICATES=1

# -------------------------------------------------------------------------------------------------
# -*- mode: bash; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=bash sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------