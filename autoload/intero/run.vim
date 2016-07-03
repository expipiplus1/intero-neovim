function! intero#run#start_process()
    if exists('g:intero_process_id')
        " echom "Intero already running, process id: " . g:intero_process_id
        return
    else
        let l:handler = s:InteroHandler.new()
        let l:job_id = jobstart(['stack', 'ghci', '--with-ghc', 'intero'], l:handler)
        if l:job_id == -1
            echom "Intero is not executable."
        elseif l:job_id == 0
            echom "job table is full, or invalid arguments"
        else
            " echom "Intero started, Process Id: " . l:job_id
            let g:intero_process_id = l:job_id
            let g:intero_handler = l:handler
            call intero#run#load_current_module()
        endif
    endif
endfunction

function! intero#run#flush_handler()
    let l:foo = 1

    while l:foo != ""
        let l:foo = g:intero_handler.get_line()
        " echom l:foo
    endwhile
endfunction

function! intero#run#end_process()
    if exists('g:intero_process_id')
        echom "Killing intero"
        call jobstop(g:intero_process_id)
    else
        echom "Intero is not running"
    endif
endfunction

function! intero#run#send_message(str)
    if !exists('g:intero_process_id')
        intero#run#start_process()
    endif
    call jobsend(g:intero_process_id, a:str . "\n")
endfunction

function! intero#run#type_at(module, row, col)
    let l:message = join([':type-at', a:module, a:row, a:col, a:row, a:col, 'it'], " ")
    " echom l:message
    call intero#run#send_message(l:message)
    let l:resp = g:intero_handler.get_line()
    " while ! (l:resp =~ ".*::.*")
    "     let l:resp = g:intero_handler.get_line()
    "     exe 'sleep 20m'
    "     echom l:resp
    " endwhile
    return l:resp
endfunction

function! intero#run#type_at_point(module)
    let l:col = intero#util#getcol()
    let l:row = line('.')
    return intero#run#type_at(a:module, l:row, l:col)
endfunction

function! intero#run#load_current_module()
    let l:module = s:get_module()
    call intero#run#send_message(":l " . l:module)
endfunction

function! s:get_module()
    " Delete until the first uppercase character and slash
    let l:module_slash = substitute(expand('%'), "^[A-Z ]*/", "", "")
    return substitute(
        \ join(
        \     split(l:module_slash, '/')
        \     , '.'
        \ ), "\.hs", "", "")
endfunction

function! intero#run#type_at_point_m()
    call intero#run#type_at_point(s:get_module())
    echom intero#run#type_at_point(s:get_module())
endfunction

let s:InteroHandler = {}

function s:InteroHandler.on_stdout(job_id, data)
    call self.stream.add(a:data)
endfunction

function s:InteroHandler.on_stderr(job_id, data)
    " call append(line('$'), self.get_name().' stderr: '.join(a:data))
endfunction

function s:InteroHandler.on_exit(job_id, data)
    call append(line('$'), self.get_name().' exited')
endfunction

function s:InteroHandler.get_line()
    return self.stream.get_line()
endfunction

function s:InteroHandler.get_name()
    return 'Intero: '
endfunction

function s:InteroHandler.new()
    let l:stream = s:InputStream.new()
    let l:instance = extend(copy(s:InteroHandler), { 'stream': l:stream })
    return l:instance
endfunction

let s:InputStream = { 'input_buffer': [] }

function! s:InputStream.get_line()
    " Retrieves a line from the current buffer. If there is more than one
    " line, it returns the last line and discards the rest.
    return join(self.input_buffer, "\n")
endfunction

function! s:InputStream.get_buffer()
    return self.input_buffer
endfunction

function! s:InputStream.add(line_list)
    echom join(a:line_list, ' ')
    if a:line_list
        echom a:line_list
        let self['input_buffer'] = self.input_buffer + a:line_list
    endif
endfunction

function! s:InputStream.new()
    let instance = copy(s:InputStream)
    return instance
endfunction
