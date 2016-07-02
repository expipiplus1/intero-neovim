let s:sessions = {}

function! intero#async#exist_session()
  return !empty(s:sessions)
endfunction

function! intero#async#register(obj)
  try
    let l:key = reltimestr(reltime()) " this value should be unique
    if !exists('s:updatetime')
      let s:updatetime = &updatetime
    endif
    let s:sessions[l:key] = a:obj
    set updatetime=100
    augroup intero-async
      execute 'autocmd CursorHold,CursorHoldI * call s:receive(' . string(l:key) . ')'
    augroup END
    return 1
  catch
    if exists('l:key') && has_key(s:sessions, l:key)
      call s:finalize(l:key)
    endif
    call intero#print_error(printf('%s %s', v:throwpoint, v:exception))
    return 0
  endtry
endfunction

function! s:receive(key)
  if !has_key(s:sessions, a:key)
    return
  endif
  let l:session = s:sessions[a:key]
  let [l:cond, l:status] = intero#util#wait(l:session.proc)
  if l:cond ==# 'run'
    call feedkeys(mode() ==# 'i' ? "\<C-g>\<Esc>" : "\<Esc>", 'n')
    return
  endif

  call s:finalize(a:key)
  call l:session.on_finish(l:cond, l:status)
endfunction

function! s:finalize(key)
  call remove(s:sessions, a:key)
  if empty(s:sessions)
    augroup intero-async
      autocmd!
    augroup END
    let &updatetime = s:updatetime
    unlet s:updatetime
  endif
endfunction

" vim: set ts=2 sw=2 et fdm=marker:
