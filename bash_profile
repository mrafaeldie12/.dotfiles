[ -r /Users/rafaeldm/.profile_lda ] && . /Users/rafaeldm/.profile_ld
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
export PATH="/usr/local/opt/php@7.3/sbin:$PATH"
export PATH="/usr/local/opt/php@7.3/bin:$PATH"
[ -r /Users/rafaeldm/.profile_lda ] && . /Users/rafaeldm/.profile_lda

echo -e "`date +"%Y-%m-%d %H:%M:%S"` direnv hooking bash"
eval "$(direnv hook bash)"
