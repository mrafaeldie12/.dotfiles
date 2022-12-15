if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export ZSH_DISABLE_COMPFIX=true

ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(z git zsh-autosuggestions copyfile copypath web-search jsontools fzf-zsh-plugin zsh-syntax-highlighting zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

export MANPATH="/usr/local/man:$MANPATH"

export LANG=en_US.UTF-8

export PATH="/usr/local/opt/php@7.3/bin:$PATH"
export PATH="/usr/local/opt/php@7.3/sbin:$PATH"
export PATH="/Users/rafaeldm/go/bin:$PATH"
export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/sbin:$PATH

export ZSH_DISABLE_COMPFIX=true
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

ZVM_VI_SURROUND_BINDKEY="s-prefix"
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

echo -e "`date +"%Y-%m-%d %H:%M:%S"` direnv hooking zsh"
eval "$(direnv hook zsh)"

export EDITOR=nvim

bindkey '[C' forward-word
bindkey '[D' backward-word
FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden"

export MONOREPO_GOPATH_MODE=1 # This is optional. Without it, GOPATH mode will be off by default
source $HOME/.dotfiles/gopathmodeFunc.bash

genie_conf() {
  export UBER_CONFIG_DIR="$GOPATH/src/code.uber.internal/infra/capeng/genie/config/"
  export UBER_ZONE="phx5"
}

alias gs="git status"
alias v="nvim"
alias e="exa -la"
alias p3="python3"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
source ~/.oh-my-zsh/custom/plugins/zsh-vi-mode/zsh-vi-mode.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
