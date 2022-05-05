[ -r /Users/rafaeldm/.profile_lda ] && . /Users/rafaeldm/.profile_lda
export MONOREPO_GOPATH_MODE=1 # This is optional. Without it, GOPATH mode will be off by default
source $HOME/gopathmodeFunc.bash
echo -e "`date +"%Y-%m-%d %H:%M:%S"` direnv hooking bash"
eval "$(direnv hook bash)"
