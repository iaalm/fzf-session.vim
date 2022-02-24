" fzf-session.vim - fzf extension to manage vim sessions.
" Inspired by ctrlp_session by Pascal Lalancette
" Maintainer:       Dominick Ng
" Version:          1.0

" Location of session files
" let g:fzf_session_path="~/.vim_sessions"

" ------------------------------------------------------------------
" Sessions
" ------------------------------------------------------------------

let s:default_action = {
  \ 'ctrl-x': 'delete',
  \ 'ctrl-v': 'overwrite' }

function! s:session_handler(line)
  if !empty(a:line)
    execute fzf_session#load(a:line)
  endif
  normal ^zz
endfunction

function! fzf_session#session()
  let raw_dir = fzf_session#path()
  if !isdirectory(expand(raw_dir))
    echohl WarningMsg
    echomsg "Invalid directory"
    echohl None
    return 0
  endif
  let dir = substitute(raw_dir, '/*$', '/', '')

  let wrapped = fzf#wrap('sessions', {
  \ 'source':  fzf_session#list(),
  \ 'options': '-m --prompt \>',
  \ 'sink': function('s:session_handler'),
  \ 'dir': dir
  \}, 0)
  return fzf#run(wrapped)
endfunction

augroup fzf_session
  autocmd!
  autocmd BufEnter,VimLeavePre * call fzf_session#persist()
augroup END

command! -nargs=1 SSave call fzf_session#save(<f-args>)
command! -nargs=0 SSave call fzf_session#save("")
command! -nargs=0 Sessions call fzf_session#session()
command! -nargs=1 SLoad call fzf_session#load(<f-args>)
command! -nargs=1 SDelete call fzf_session#delete(<f-args>)
command! -nargs=0 SQuit call fzf_session#quit()
command! -nargs=0 SList echo join(fzf_session#list(), ", ")
