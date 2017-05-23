"=============================================================================
" File: auto-gogtags.vim
" Author: cowsys
" Created: 2017-05-23
"=============================================================================

scriptencoding utf-8

if !exists('g:loaded_auto_gogtags')
    finish
endif
let g:loaded_auto_gogtags = 1

let s:save_cpo = &cpo
set cpo&vim

"------------------------
" setting
"------------------------
if !exists("g:auto_gogtags")
  let g:auto_gogtags = 0
endif

if !exists("g:auto_gogtags_directory_list")
  let g:auto_gogtags_directory_list = ['.']
endif

if !exists("g:auto_gogtags_gpath_name")
  let g:auto_gogtags_gpath_name = 'GPATH'
endif

if !exists("g:auto_gogtags_grtags_name")
  let g:auto_gogtags_grtags_name = 'GRTAGS'
endif

if !exists("g:auto_gogtags_gogtags_name")
  let g:auto_gogtags_gogtags_name = 'gogtags'
endif

if !exists("g:auto_gogtags_bin_path")
  let g:auto_gogtags_bin_path = 'gogtags'
endif

if !exists("g:auto_global_bin_path")
  let g:auto_global_bin_path = 'global'
endif

if !exists("g:auto_gogtags_filetype_mode")
  let g:auto_gogtags_filetype_mode = 0
endif

if !exists("g:auto_gogtags_is_making_str")
  let g:auto_gogtags_is_making_str = 'gogtags making'
endif

if !exists("g:auto_gogtags_is_not_making_str")
  let g:auto_gogtags_is_not_making_str = 'gogtags free'
endif
"------------------------
" function
"------------------------
function! auto_gogtags#get_gogtags_path(tags_name)
  let s:path = ''
  for s:directory in g:auto_gogtags_directory_list
    if isdirectory(s:directory)
      if g:auto_gogtags_filetype_mode > 0
        if &filetype !=# ''
          let a:tags_name = &filetype.'.'.a:tags_name
        endif
      endif
      let s:path = s:directory.'/'.a:tags_name
      break
    endif
  endfor

  return s:path
endfunction

function! auto_gogtags#gpath_path()
  return auto_gogtags#get_gogtags_path(g:auto_gogtags_gpath_name)
endfunction

function! auto_gogtags#grtags_path()
  return auto_gogtags#get_gogtags_path(g:auto_gogtags_grtags_name)
endfunction

function! auto_gogtags#gogtags_path()
  return auto_gogtags#get_gogtags_path(g:auto_gogtags_gogtags_name)
endfunction

function! auto_gogtags#gogtags_cmd()
  let s:gogtags_cmd = ''
  let s:tags_bin_path = g:auto_gogtags_bin_path
  let s:gogtags_cmd = s:tags_bin_path.' -v'
  return s:gogtags_cmd
endfunction

function! auto_gogtags#update_cmd()
  let s:gogtags_cmd = ''
  let s:tags_bin_path = g:auto_global_bin_path
  let s:gogtags_cmd = s:tags_bin_path.' -uv'
  return s:gogtags_cmd
endfunction

function! auto_gogtags#gogtags(recreate)
  if a:recreate < 0 && g:auto_gogtags != 1
    return
  endif

  if auto_gogtags#is_making_gogtags() == 1
    return
  endif

  if a:recreate > 0
    silent! execute '!rm '.auto_gogtags#gpath_path().' 2>/dev/null'
    silent! execute '!rm '.auto_gogtags#grtags_path().' 2>/dev/null'
    silent! execute '!rm '.auto_gogtags#gogtags_path().' 2>/dev/null'
  elseif filereadable(auto_gogtags#gogtags_path()) == 0
    return
  endif

  if a:recreate > 0
    let s:cmd = auto_gogtags#gogtags_cmd()
  else
    let s:cmd = auto_gogtags#update_cmd()
  endif
  if len(s:cmd) > 0
    silent! execute '!sh -c "'.s:cmd.'" 2>/dev/null &'
  endif

  if a:recreate > 0
    redraw!
  endif
endfunction

function! auto_gogtags#is_making_gogtags()
  let ps = system('ps')
  return match(ps, 'gogtags.*-v') != -1
endfunction

function! auto_gogtags#is_making_gogtags_str()
  let str = 'none'
  if auto_gogtags#is_making_gogtags() == 1
    let str = g:auto_gogtags_is_making_str
  else
    let str = g:auto_gogtags_is_not_making_str
  endif
  return str
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
