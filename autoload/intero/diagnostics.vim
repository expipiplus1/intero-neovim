function! intero#diagnostics#report()
    echomsg 'Current filetype:' &l:filetype
    call s:check_filetype()

    echomsg 'intero.vim version:' join(intero#version(), '.')

    call s:ensure_intero_installed()

    let l:intero = executable('stack exec -- intero --version')
    echomsg 'ghc-mod is executable:' l:intero
    if !l:intero
        echomsg '  Your $PATH:' $PATH
        return
    endif

    if &l:filetype == 'haskell'
        if !exists('b:did_ftplugin_intero')
            call intero#util#print_error("intero.vim's ftplugin isn't loaded. You must copy the `after' directory.")
        endif
    else
        call intero#util#print_warning('Run this command in the buffer opening a Haskell file')
    endif

    let l:cmd = intero#build_command(['debug'])
    echomsg 'ghc-mod debug command:' join(l:cmd, ' ')
    for l:line in split(intero#system(l:cmd), '\n')
        echomsg l:line
    endfor
endfunction

function! s:ensure_intero_installed()
    let l:version = system(
    ['stack', 'exec', '--verbosity', 'silent', '--', 'intero' '--version'])
    echom "Version: " . l:version
    if !l:version
        echom "Intero note installed."
        execute "! stack build intero"
    endif
endfunction

function! s:check_filetype()
    redir => l:ft
    silent filetype
    redir END
    echomsg l:ft[1 :]
    if l:ft !~# 'plugin:ON'
        call intero#util#print_error("You didn't enable filetype plugin. I highly recommend putting `filetype plugin indent on` to your vimrc")
    endif
endfunction
