" Mapping 
imap jk <Esc>

imap <Esc> <Nop>

imap <Up> <nop>
imap <Down> <nop>

nmap <Up> <nop>
nmap <Down> <nop>
nmap <Left> <nop>
nmap <Right> <nop>

exmap unfoldall obcommand editor:unfold-all
nmap zR :unfoldall

exmap foldall obcommand editor:fold-all
nmap zM :foldall

exmap foldtoggle obcommand editor:toggle-fold
nmap za :foldtoggle
