""""""""""
" Util:
"
" This file contains functions that are useful for multiple modules, but that
" don't fit specifically in any one.
"""""""""

function! intero#util#get_intero_window()
    " Returns the window ID that the Intero process is on, or -1 if it isn't
    " found.
    return bufwinnr('stack ghci --with-ghc intero')
endfunction

function! intero#util#path_to_module(path)
    " Converts a path like `src/Main/Foo/Bar.hs` to Main.Foo.Bar
    return substitute(
        \ join(split(substitute(a:path, "^[A-Z ]*/", "", ""), '/') , '.'),
        \ "\.hs", "", "")
endfunction

""""""""""
" The following functions were copied from ghcmod-vim.
""""""""""

function! intero#util#print_warning(msg) "{{{
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunction "}}}

function! intero#util#print_error(msg) "{{{
    echohl ErrorMsg
    echomsg a:msg
    echohl None
endfunction "}}}

function! intero#util#getcol() "{{{
    let l:line = line('.')
    let l:col = col('.')
    let l:str = getline(l:line)[:(l:col - 1)]
    let l:tabcnt = len(substitute(l:str, '[^\t]', '', 'g'))
    return l:col + 7 * l:tabcnt
endfunction "}}}

function! intero#util#tocol(line, col) "{{{
    let l:str = getline(a:line)
    let l:len = len(l:str)
    let l:col = 0
    for l:i in range(1, l:len)
        let l:col += (l:str[l:i - 1] ==# "\t" ? 8 : 1)
        if l:col >= a:col
            return l:i
        endif
    endfor
    return l:len + 1
endfunction "}}}

" vim: set ts=4 sw=4 et fdm=marker:
