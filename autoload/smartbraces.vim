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
  call search('\v\C%(%([^[:digit:]IVX]|[)''"])\zs[.]|[!?])[[:space:])''"]|[.!?]$', 'W')
endfunction
