#!/bin/zsh

export TERM='xterm-256color'
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

export PATH="$BINDIR:$HOME/bin:$HOME/projects/ndn/dh/bin:$HOME/perl5/bin:$HOME/.cargo/bin:$PATH"
export LD_LIBRARY_PATH="$LOCALDIR/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="$LOCALDIR/lib/pkgconfig:$LOCALDIR/share/pkgconfig:$PKG_CONFIG_PATH"
export MANPATH="$DATADIR/man:$MANPATH"

if [ "$(uname)" = "Darwin" ]; then
  eval $(/opt/homebrew/bin/brew shellenv)

  if command -v brew &>/dev/null; then
    export BREWDIR="/opt/homebrew/opt"
    export PATH="$BREWDIR/curl/bin:$PATH"
    export PATH="$BREWDIR/ruby/bin:$PATH"
    export PATH="$BREWDIR/ncurses/bin:$PATH"
    export PATH="$BREWDIR/make/libexec/gnubin:$PATH"
    export PATH="$BREWDIR/gawk/libexec/gnubin:$PATH"
    export PATH="$BREWDIR/grep/libexec/gnubin:$PATH"
    export PATH="$BREWDIR/gnu-sed/libexec/gnubin:$PATH"
    export PATH="$BREWDIR/gnu-tar/libexec/gnubin:$PATH"
    export PATH="$BREWDIR/coreutils/libexec/gnubin:$PATH"
    export PATH="$BREWDIR/findutils/libexec/gnubin:$PATH"
    export LD_LIBRARY_PATH="$BREWDIR/curl/lib:$LD_LIBRARY_PATH"
    export LD_LIBRARY_PATH="$BREWDIR/ruby/lib:$LD_LIBRARY_PATH"
    export LD_LIBRARY_PATH="$BREWDIR/ncurses/lib:$LD_LIBRARY_PATH"
    export LD_LIBRARY_PATH="$BREWDIR/readline/lib:$LD_LIBRARY_PATH"
    export PKG_CONFIG_PATH="$BREWDIR/curl/lib/pkgconfig:$PKG_CONFIG_PATH"
    export PKG_CONFIG_PATH="$BREWDIR/ruby/lib/pkgconfig:$PKG_CONFIG_PATH"
    export PKG_CONFIG_PATH="$BREWDIR/ncurses/lib/pkgconfig:$PKG_CONFIG_PATH"
    export PKG_CONFIG_PATH="$BREWDIR/readline/lib/pkgconfig:$PKG_CONFIG_PATH"

    [[ -f ~/.config/homebrew/brewenv.sh ]] && source ~/.config/homebrew/brewenv.sh
  fi
elif [ "$(uname)" = "Linux" ]; then
  if command -v fc-cache &>/dev/null && [[ -d "$DATADIR/fonts" ]]; then
    fc-cache -f "$DATADIR/fonts"
  fi
fi

# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :