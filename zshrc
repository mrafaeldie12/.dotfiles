export PATH="/usr/local/opt/php@7.3/bin:$PATH"
export PATH="/usr/local/opt/php@7.3/sbin:$PATH"
export PATH="/Users/rafaeldm/go/bin:$PATH"

echo -e "`date +"%Y-%m-%d %H:%M:%S"` direnv hooking zsh"
eval "$(direnv hook zsh)"

export EDITOR=nvim

bindkey '[C' forward-word
bindkey '[D' backward-word

export MONOREPO_GOPATH_MODE=1 # This is optional. Without it, GOPATH mode will be off by default
source $HOME/.dotfiles/gopathmodeFunc.bash
