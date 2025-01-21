#!/usr/bin/env zsh

#############
#  Aliases  #
#############

# List declared aliases, functions, paths
alias paths='echo -e ${PATH//:/\\n}'
alias aliases='alias | sed "s/=.*//"'
alias functions='declare -f | grep "^[a-z].* ()" | sed "s/{$//"'

# Has package
alias has='curl -sL https://git.io/_has | bash -s '

# CD Shortcuts
alias dh='cd $DHSPACE'
alias dots='cd $DOTFILES'

# Edit configs
alias nrc='${=EDITOR} $XDG_CONFIG_HOME/nvim/init.lua'
alias vrc='${=EDITOR} $HOME/.vimrc'
alias wrc='${=EDITOR} $XDG_CONFIG_HOME/wezterm/wezterm.lua'
alias zrc='${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc'
alias zenv='${=EDITOR} $HOME/.zshenv'
alias zpro='${=EDITOR} ${ZDOTDIR:-$HOME}/.zprofile'

# Edit aliases
alias aliasrc='${=EDITOR} $ZDOTDIR/.zshrc.d/aliases.zsh'

# Mac
alias macupdate='sudo softwareupdate -i -a'

# Brew
alias brewupdate='brew update && brew upgrade && brew cleanup'

# ASDF
alias asdfplugadd='cut -d" " -f1 $ASDF_DEFAULT_TOOL_VERSIONS_FILENAME|xargs -i asdf plugin add  {}'
alias asdfupdate='asdf update --head && asdf plugin update --all'

# Zplug
alias zplugupdate='zplug update && zplug install && zplug clean && zplug clear'

# ZSH Profiling
alias zdebug="time ZSH_DEBUG=1 zsh -i -c exit"
alias zbench='$XDG_DATA_HOME/zsh-bench/zsh-bench'

# LDE
alias ldelog='lde logs -ftall '

# Stow
alias stowdir='stow --no-folding --dotfiles --verbose=1 -R -t ~ '
alias unstowdir='stow --verbose=1 -D '

# Nvim
alias vi='${=EDITOR}'
alias vim='${=EDITOR}'

# Git
alias gg='git grep -E'

# SSH
alias rotatekeys='source $HOME/ssh-key-manager.sh && rotate_keys'
alias displaykeys='source $HOME/ssh-key-manager.sh && display_public_keys'

# Arduino
alias ard='arduino-cli'
alias ardc='arduino-cloud-cli'

# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------
