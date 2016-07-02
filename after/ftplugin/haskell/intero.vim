if exists('b:did_ftplugin_intero') && b:did_ftplugin_intero
    finish
endif
let b:did_ftplugin_intero = 1

call intero#diagnostics#ensure_intero_installed()

call intero#run#start_process()

if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= ' | '
else
    let b:undo_ftplugin = ''
endif

command! -buffer -nargs=0 -bang InteroType call intero#command#type(<bang>0)
command! -buffer -nargs=0 -bang InteroTypeInsert call intero#command#type_insert(<bang>0)
command! -buffer -nargs=0 -bang InteroSplitFunCase call intero#command#split_function_case(<bang>0)
command! -buffer -nargs=0 -bang InteroSigCodegen call intero#command#initial_code_from_signature(<bang>0)
command! -buffer -nargs=? -bang InteroInfo call intero#command#info(<q-args>, <bang>0)
command! -buffer -nargs=0 InteroTypeClear call intero#command#type_clear()
command! -buffer -nargs=? -bang InteroInfoPreview call intero#command#info_preview(<q-args>, <bang>0)
command! -buffer -nargs=0 -bang InteroCheck call intero#command#make('check', <bang>0)
command! -buffer -nargs=0 -bang InteroLint call intero#command#make('lint', <bang>0)
command! -buffer -nargs=0 -bang InteroCheckAsync call intero#command#async_make('check', <bang>0)
command! -buffer -nargs=0 -bang InteroLintAsync call intero#command#async_make('lint', <bang>0)
command! -buffer -nargs=0 -bang InteroCheckAndLintAsync call intero#command#check_and_lint_async(<bang>0)
command! -buffer -nargs=0 -bang InteroExpand call intero#command#expand(<bang>0)
let b:undo_ftplugin .= join(map([
            \ 'InteroType',
            \ 'InteroTypeInsert',
            \ 'InteroSplitFunCase',
            \ 'InteroSigCodegen',
            \ 'InteroInfo',
            \ 'InteroInfoPreview',
            \ 'InteroTypeClear',
            \ 'InteroCheck',
            \ 'InteroLint',
            \ 'InteroCheckAsync',
            \ 'InteroLintAsync',
            \ 'InteroCheckAndLintAsync',
            \ 'InteroExpand'
            \ ], '"delcommand " . v:val'), ' | ')
let b:undo_ftplugin .= ' | unlet b:did_ftplugin_intero'

" Ensure syntax highlighting for intero#detect_module()
syntax sync fromstart

" vim: set ts=4 sw=4 et fdm=marker:
