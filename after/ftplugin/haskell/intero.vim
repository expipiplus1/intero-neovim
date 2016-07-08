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

" Starts the Intero process in the background.
command! -buffer -nargs=0 -bang InteroStart call intero#process#start()
" Kills the Intero process.
command! -buffer -nargs=0 -bang InteroKill call intero#process#kill()
" Opens the Intero buffer.
command! -buffer -nargs=0 -bang InteroOpen call intero#process#open()
" Hides the Intero buffer.
command! -buffer -nargs=0 -bang InteroHide call intero#process#hide()
" Loads the current module in Intero.
command! -buffer -nargs=0 -bang InteroLoadCurrentModule call intero#repl#load_current_module()
" Prompts user for a string to eval
command! -buffer -nargs=0 -bang InteroEval call intero#repl#eval()
" Gets the specific type at the current point
command! -buffer -nargs=0 -bang InteroSpecificType call intero#repl#type(0)
" Gets the type at the current point
command! -buffer -nargs=0 -bang InteroGenericType call intero#repl#type(1)
" Gets info for the identifier at the current point
command! -buffer -nargs=0 -bang InteroInfo call intero#repl#info()
" Echo the last response from the REPL
command! -buffer -nargs=0 -bang InteroResponse call intero#repl#get_last_response()

" Some recommended keymaps:
" nnoremap <Leader>hio :InteroOpen<CR>
" nnoremap <Leader>hik :InteroKill<CR>
" nnoremap <Leader>hic :InteroHide<CR>
" nnoremap <Leader>hil :InteroLoadCurrentModule<CR>
" nnoremap <Leader>hie :InteroEval<CR>
" nnoremap <Leader>hit :InteroGenericType<CR>
" nnoremap <Leader>hii :InteroInfo<CR>
" nnoremap <Leader>hip :InteroResponse<CR>

let b:undo_ftplugin .= join(map([
            \ 'InteroType',
            \ 'InteroOpen',
            \ 'InteroKill',
            \ 'InteroHide',
            \ 'InteroLoadCurrentModule',
            \ 'InteroLoadEval',
            \ 'InteroResponse',
            \ ], '"delcommand " . v:val'), ' | ')
let b:undo_ftplugin .= ' | unlet b:did_ftplugin_intero'

call intero#process#start()
call intero#repl#load_current_module()

" vim: set ts=4 sw=4 et fdm=marker:
"
call intero#repl#eval(":set +c")
