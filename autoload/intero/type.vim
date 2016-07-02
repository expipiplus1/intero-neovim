function! intero#type#new(types, group) "{{{
  let l:obj = deepcopy(s:intero_type)
  let l:obj.types = a:types
  let l:obj.group = a:group

  augroup intero-type-highlight
    autocmd! * <buffer>
    autocmd BufEnter,WinEnter <buffer> call s:on_enter()
    autocmd BufLeave,WinLeave <buffer> call s:on_leave()
  augroup END

  return l:obj
endfunction "}}}

function! s:on_enter() "{{{
  if exists('b:intero_type')
    call b:intero_type.highlight()
  endif
endfunction "}}}

function! s:on_leave() "{{{
  if exists('b:intero_type')
    call b:intero_type.clear_highlight()
  endif
endfunction "}}}

let s:intero_type = {
      \ 'ix': 0,
      \ 'types': [],
      \ 'match_id': -1,
      \ }

function! s:intero_type.spans(line, col) "{{{
  if empty(self.types)
    return 0
  endif
  let [l:line1, l:col1, l:line2, l:col2] = self.types[self.ix][0]
  return l:line1 <= a:line && a:line <= l:line2 && l:col1 <= a:col && a:col <= l:col2
endfunction "}}}

function! s:intero_type.type() "{{{
  return self.types[self.ix][1]
endfunction "}}}

function! s:intero_type.incr_ix() "{{{
  let self.ix = (self.ix + 1) % len(self.types)
endfunction "}}}

function! s:intero_type.highlight() "{{{
  if empty(self.types)
    return
  endif
  call self.clear_highlight()
  let [l:line1, l:col1, l:line2, l:col2] = self.types[self.ix][0]
  let l:col1 = intero#util#tocol(l:line1, l:col1)
  let l:col2 = intero#util#tocol(l:line2, l:col2)
  let self.match_id = matchadd(self.group, '\%' . l:line1 . 'l\%' . l:col1 . 'c\_.*\%' . l:line2 . 'l\%' . l:col2 . 'c')
endfunction "}}}

function! s:intero_type.clear_highlight() "{{{
  if self.match_id != -1
    call matchdelete(self.match_id)
    let self.match_id = -1
  endif
endfunction "}}}

" vim: set ts=4 sw=4 et fdm=marker:
