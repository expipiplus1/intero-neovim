if exists('b:did_ftplugin_intero') && b:did_ftplugin_intero
    finish
endif
let b:did_ftplugin_intero = 1

call intero#process#ensure_installed()

if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= ' | '
else
    let b:undo_ftplugin = ''
endif

command! -buffer -nargs=0 -bang InteroStart call intero#process#start()
command! -buffer -nargs=0 -bang InteroLoadCurrentModule call intero#process#load_current_module()

nnoremap <Leader>is :InteroStart<CR>
nnoremap <Leader>il :InteroLoadCurrentModule

let b:undo_ftplugin .= join(map([
            \ 'InteroType',
            \ ], '"delcommand " . v:val'), ' | ')
let b:undo_ftplugin .= ' | unlet b:did_ftplugin_intero'

" " Ensure syntax highlighting for intero#detect_module()
" syntax sync fromstart

" vim: set ts=4 sw=4 et fdm=marker:
