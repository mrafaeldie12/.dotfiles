export PATH="/usr/local/opt/php@7.3/bin:$PATH"
export PATH="/usr/local/opt/php@7.3/sbin:$PATH"

echo -e "`date +"%Y-%m-%d %H:%M:%S"` direnv hooking zsh"
eval "$(direnv hook zsh)"
