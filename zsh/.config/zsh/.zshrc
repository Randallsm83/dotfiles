#!/bin/zsh

# ========================= Zplug Setup ========================================
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# ========================= Plugins Setup ======================================

# ---- ZSH Syntax Theme -------
[[ -f ~/.config/zsh/colors/gruvbox.zsh-syntax-theme ]] && source ~/.config/zsh/colors/gruvbox.zsh-syntax-theme

# ---- Language Plugins -------
zplug "lukechilds/zsh-nvm"
zplug "mattberther/zsh-pyenv"
zplug "DhavalKapil/luaver"
zplug "wushenrong/zsh-plenv"

# ---- Oh-My-Zsh Plugins ------
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/npm", from:oh-my-zsh
zplug "plugins/nvm", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/ssh-agent", from:oh-my-zsh
zplug "plugins/common-aliases", from:oh-my-zsh

# ---- Zsh Users Plugins -------
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:2

# ---- Supercrab Tree ----------
zplug "supercrabtree/k"

# ---- FZF Setup ---------------
zplug "junegunn/fzf", use:"shell/*.zsh", hook-build:"./install --all"

# ---- Diff So Fancy ---------
zplug "so-fancy/diff-so-fancy", as:command, use:"diff-so-fancy"

# ========================= Zplug Install and Load =============================
if ! zplug check --verbose; then
  echo
  zplug install
fi

zplug load

# ========================= General Settings ===================================
# History settings
export HISTFILE="$ZDOTDIR/zsh_history"
export HISTSIZE=500000
export SAVEHIST=500000

setopt APPENDHISTORY          # Append to history file, do not overwrite
setopt EXTENDED_HISTORY       # Record command execution time
setopt INC_APPEND_HISTORY     # Write to history file immediately
setopt SHARE_HISTORY          # Share history across all sessions
setopt HIST_VERIFY            # Don't execute immediately upon history expansion
setopt HIST_IGNORE_SPACE      # Ignore commands with leading spaces
setopt HIST_REDUCE_BLANKS     # Remove unnecessary blanks
setopt HIST_IGNORE_DUPS       # Ignore duplicate commands
setopt HIST_FIND_NO_DUPS      # Do not display old duplicates in history search
setopt HIST_SAVE_NO_DUPS      # Do not save duplicate commands in history
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.

# ========================= Key Bindings =======================================

# --- History substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ========================= Visual Settings ====================================

# ---- Set dircolors and completion colors ----
eval "$(dircolors --sh ~/.config/zsh/colors/gruvbox.default.dircolors)"
IFS=: read -rA ls_colors_array <<<"$LS_COLORS"
zstyle ':completion:*' list-colors "${ls_colors_array[@]}"

# ========================= Source Configurations ==============================
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.aliases.ndn ]] && source ~/.aliases.ndn
[[ -f ~/.config/wezterm/wezterm.sh ]] && source ~/.config/wezterm/wezterm.sh

# ========================= Starship Prompt ====================================
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/my-gruvbox.toml"

eval "$(starship init zsh)"

# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------
