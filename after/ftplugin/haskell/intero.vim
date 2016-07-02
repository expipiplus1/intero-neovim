if exists('b:did_ftplugin_intero') && b:did_ftplugin_intero
    finish
endif
let b:did_ftplugin_intero = 1

call intero#diagnostics#report()

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

" vim: set ts=4 sw=4 et fdm=marker:
