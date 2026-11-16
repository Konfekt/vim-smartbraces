" The motion functions take the mode they are called from: 'n' (normal), 'v'
" or 'x' (visual) and 'o' (operator-pending). In operator-pending mode the
" forward motions are inclusive, so that their target character is included,
" and the backward motion is exclusive, as Vim's own backward motions are.

" Whether the keys should keep their native behavior in the current window.
function! s:native() abort
  return get(g:, 'smartbraces_spell', 0) && !&l:spell
endfunction

" Restore the Visual selection, or start one to make an operator-pending
" motion inclusive. This resets v:count, so callers read it beforehand.
function! s:prepare(mode, inclusive) abort
  if a:mode is# 'v' || a:mode is# 'x'
    normal! gv
  elseif a:mode is# 'o' && a:inclusive
    normal! v
  endif
endfunction

function! smartbraces#OpenBrace(mode) abort
  let counts = v:count1
  let native = s:native()
  call s:prepare(a:mode, 0)
  if native
    exe 'normal! ' . counts . '{'
    return
  endif

  let line = getline('.')
  " on the first non-blank of a paragraph, go to the start of the previous one
  if line =~# '\S' && getline(line('.') - 1) !~# '\S'
        \ && col('.') <= matchend(line, '^\s*') + 1
    let counts += 1
  endif
  exe 'normal! ' . counts . '{'
  call search('^\s*\S', 'ecWz')
endfunction

function! smartbraces#CloseBrace(mode) abort
  let counts = v:count1
  let native = s:native()
  call s:prepare(a:mode, !native)
  if native
    exe 'normal! ' . counts . '}'
    return
  endif

  let line = getline('.')
  " on the last non-blank of a paragraph, go to the end of the next one
  if line =~# '\S' && getline(line('.') + 1) !~# '\S'
        \ && line !~# '\%>' . col('.') . 'c\S'
    let counts += 1
  endif
  exe 'normal! ' . counts . '}'
  call search('\S\s*$', 'bcWz')
endfunction

function! smartbraces#CloseParenthesis(mode) abort
  let counts = v:count1
  let native = s:native()
  call s:prepare(a:mode, !native)
  if native
    exe 'normal! ' . counts . ')'
    return
  endif

  if counts > 1
    exe 'normal! ' . (counts - 1) . ')'
  endif
  if !s:sentence_end() && a:mode is# 'o'
    " no sentence ahead: cancel the selection, so that the operator does nothing
    exe "normal! \<Esc>"
  endif
endfunction

" A sentence ends at a '.', '!' or '?', followed by any closing ')', ']', '"'
" or ''' and then white space or the end of the line. A '.' right after a
" digit or roman numeral, as in an enumeration, only counts at the end of a
" line.
let s:sentence_end_pattern =
      \ '\v\C%([^[:digit:]IVX][.]|[!?])[])''"]*%(\s|$)@=|[.!?][])''"]*$'

" Move the cursor to the end of the sentence after it and return 1, or return
" 0 if there is none. As for Vim's own sentence motions, the end of a
" paragraph also ends a sentence; the search never crosses it.
function! s:sentence_end() abort
  let here = [line('.'), col('.')]
  let first = nextnonblank(here[0])
  while first > 0
    let last = first
    while last < line('$') && getline(last + 1) =~# '\S'
      let last += 1
    endwhile
    let par_end = [last, match(getline(last), '\S\s*$') + 1]
    if s:before(here, par_end)
      let target = searchpos(s:sentence_end_pattern, 'nWe', last)
      call cursor(target[0] ? target : par_end)
      return 1
    endif
    " at the end of this paragraph: look in the next one
    let first = nextnonblank(last + 1)
  endwhile
  return 0
endfunction

function! s:before(pos1, pos2) abort
  return a:pos1[0] < a:pos2[0] || a:pos1[0] == a:pos2[0] && a:pos1[1] < a:pos2[1]
endfunction
