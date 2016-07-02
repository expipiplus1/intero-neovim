function! intero#run#start_process()
    if exists('g:intero_process_id')
        " echo "Intero already running, process id: " . g:intero_process_id
        return
    else
        let l:handler = s:InteroHandler.new()
        let l:job_id = jobstart(['stack', 'ghci', '--with-ghc', 'intero'], l:handler)
        if l:job_id == -1
            echo "Intero is not executable."
        elseif l:job_id == 0
            echo "job table is full, or invalid arguments"
        else
            " echo "Intero started, Process Id: " . l:job_id
            let g:intero_process_id = l:job_id
            let g:intero_handler = l:handler
            call intero#run#flush_handler()
        endif
    endif
endfunction

function! intero#run#flush_handler()
    let l:foo = 1

    while l:foo != ""
        let l:foo = g:intero_handler.get_line()
    endwhile
endfunction

function! intero#run#end_process()
    if exists('g:intero_process_id')
        echo "Killing intero"
        call jobstop(g:intero_process_id)
    else
        echo "Intero is not running"
    endif
endfunction

function! intero#run#send_message(str)
    if !exists('g:intero_process_id')
        intero#run#start_process()
    endif
    call jobsend(g:intero_process_id, a:str . "\n")
endfunction

function! intero#run#type_at(module, row, col)
   call intero#run#send_message(join([':type-at', a:module, a:row, a:col, a:row, a:col, 'it'], " "))
   echo g:intero_handler.get_line()
endfunction

function! intero#run#type_at_point(module)
    let l:col = intero#util#getcol()
    let l:row = line('.')
    call intero#run#type_at(a:module, l:row, l:col)
endfunction

function! s:get_module()
    let l:fname = expand('%')
    " Delete until the first uppercase character
    let l:module_slash = substitute(l:fname, "^[A-Z ]+/", "", "")
    let l:module = substitute(join(split(l:module_slash, '/'), '.'), "\.hs", "", "")
    call intero#run#type_at_point(l:module)
endfunction

function! intero#run#type_at_point_m()
    call intero#run#type_at_point(s:get_module())
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

let s:InputStream = { 'input_buffer': '' }

function! s:InputStream.get_line()
" Retrieves a line from the current buffer. If there isn't a line in the
" buffer, then it returns 0.
    let l:buffer = self.input_buffer

    if l:buffer =~ "\n"
        let l:split = split(l:buffer, "\n")
        let l:first_line = l:split[0]
        let self['input_buffer'] = join(l:split[1:-1], "\n")
        return l:first_line
    else
        return 0
    endif
endfunction

function! s:InputStream.get_buffer()
    return self.input_buffer
endfunction

function! s:InputStream.add(str)
    let self['input_buffer'] = self.input_buffer . join(a:str, "\n")
endfunction

function! s:InputStream.new()
    let instance = copy(s:InputStream)
    return instance
endfunction
