"=============================================================================
" File: auto-gogtags.vim
" Author: cowsys
" Created: 2017-05-23
"=============================================================================

scriptencoding utf-8

if exists('g:loaded_auto_gogtags')
    finish
endif
let g:loaded_auto_gogtags = 1

let s:save_cpo = &cpo
set cpo&vim

augroup auto_gogtags
  autocmd!
  autocmd BufWritePost * call auto_gogtags#gogtags(-1)
augroup END

command! gogtagsCreate call auto_gogtags#gogtags(1)
command! gogtagsUpdate call auto_gogtags#gogtags(0)

let &cpo = s:save_cpo
unlet s:save_cpo
