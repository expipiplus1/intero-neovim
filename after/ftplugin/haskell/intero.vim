if exists('b:did_ftplugin_intero') && b:did_ftplugin_intero
  finish
endif
let b:did_ftplugin_intero = 1

if !exists('s:has_vimproc')
  try
    call vimproc#version()
    let s:has_vimproc = 1
  catch /^Vim\%((\a\+)\)\=:E117/
    let s:has_vimproc = 0
  endtry
endif

if !s:has_vimproc
  echohl ErrorMsg
  echomsg 'intero: vimproc.vim is not installed!'
  echohl None
  finish
endif

if !exists('s:has_ghc_mod')
  let s:has_ghc_mod = 0

  if !executable('ghc-mod')
    call intero#util#print_error('intero: ghc-mod is not executable!')
    finish
  endif

  let s:required_version = [5, 0, 0]
  if !intero#util#check_version(s:required_version)
    call intero#util#print_error(printf('intero: requires ghc-mod %s or higher', join(s:required_version, '.')))
    finish
  endif

  let s:has_ghc_mod = 1
endif

if !s:has_ghc_mod
  finish
endif

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif

command! -buffer -nargs=0 -bang interoType call intero#command#type(<bang>0)
command! -buffer -nargs=0 -bang interoTypeInsert call intero#command#type_insert(<bang>0)
command! -buffer -nargs=0 -bang interoSplitFunCase call intero#command#split_function_case(<bang>0)
command! -buffer -nargs=0 -bang interoSigCodegen call intero#command#initial_code_from_signature(<bang>0)
command! -buffer -nargs=? -bang interoInfo call intero#command#info(<q-args>, <bang>0)
command! -buffer -nargs=0 interoTypeClear call intero#command#type_clear()
command! -buffer -nargs=? -bang interoInfoPreview call intero#command#info_preview(<q-args>, <bang>0)
command! -buffer -nargs=0 -bang interoCheck call intero#command#make('check', <bang>0)
command! -buffer -nargs=0 -bang interoLint call intero#command#make('lint', <bang>0)
command! -buffer -nargs=0 -bang interoCheckAsync call intero#command#async_make('check', <bang>0)
command! -buffer -nargs=0 -bang interoLintAsync call intero#command#async_make('lint', <bang>0)
command! -buffer -nargs=0 -bang interoCheckAndLintAsync call intero#command#check_and_lint_async(<bang>0)
command! -buffer -nargs=0 -bang interoExpand call intero#command#expand(<bang>0)
let b:undo_ftplugin .= join(map([
      \ 'interoType',
      \ 'interoTypeInsert',
      \ 'interoSplitFunCase',
      \ 'interoSigCodegen',
      \ 'interoInfo',
      \ 'interoInfoPreview',
      \ 'interoTypeClear',
      \ 'interoCheck',
      \ 'interoLint',
      \ 'interoCheckAsync',
      \ 'interoLintAsync',
      \ 'interoCheckAndLintAsync',
      \ 'interoExpand'
      \ ], '"delcommand " . v:val'), ' | ')
let b:undo_ftplugin .= ' | unlet b:did_ftplugin_intero'

" Ensure syntax highlighting for intero#detect_module()
syntax sync fromstart

" vim: set ts=2 sw=2 et fdm=marker:
