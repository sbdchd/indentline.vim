if get(g:, 'indentline_loaded', 0) || !has('conceal')
  finish
endif

let g:indentline_loaded = 1

function! s:Enable() abort
  " only enable if not in ignored_filetypes
  let default_ignored_filetypes = ['help', 'man']
  if (index(get(g:, 'indentline_ignored_filetypes', default_ignored_filetypes), &filetype) >= 0)
    return
  endif

  " only enable if not in ignored_buftypes
  let default_ignored_buftypes = ['terminal']
  if (index(get(g:, 'indentline_ignored_buftypes', default_ignored_buftypes), &buftype) >= 0)
    return
  endif

  " disable indentlines when diff is set
  if &diff
    return
  endif

  if !exists('w:indentline_indent_markers')
    let w:indentline_indent_markers = []
  endif

  let &concealcursor = 'inc'
  let &conceallevel = 2

  let space = &shiftwidth == 0 ? &tabstop : &shiftwidth

  let default_indentline_char = &encoding ==# 'utf-8' ? '¦' : '|'

  let conceal_char = get(g:, 'indentline_char', default_indentline_char)

  for i in range(space + 1, space * get(g:, 'indentline_max_indent_level', 20) + 1, space)
    call add(w:indentline_indent_markers,
          \ matchadd('Conceal', '^\s\+\zs\%' . i . 'v ', 0, -1, {'conceal': conceal_char}))
  endfor
endfunction

function! s:Disable() abort
  " delete the matches by id so we don't clear the matches from other
  " plugins like ALE, Neomake, etc.
  for id in get(w:, 'indentline_indent_markers', [])
    try
      call matchdelete(id)
    catch /^Vim\%((\a\+)\)\=:E80[23]/
    endtry
  endfor
  let w:indentline_indent_markers = []
endfunction

function! s:indentlinesToggle() abort
  if !empty(get(w:, 'indentline_indent_markers', []))
    call s:Disable()
  else
    call s:Enable()
  endif
endfunction

" refresh the markers so that they respect any changes to the &shiftwidth
function! s:Refresh() abort
  call s:Disable()
  call s:Enable()
endfunction

augroup indentline
  autocmd!
  autocmd WinEnter,BufWinEnter * call <SID>Enable()
  autocmd FileType * call <SID>Refresh()
augroup END

command! IndentlineEnable call <SID>Enable()
command! IndentlineDisable call <SID>Disable()
command! IndentlineRefresh call <SID>Refresh()
