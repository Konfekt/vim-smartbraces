function! smartbraces#OpenBrace(mode) abort
  if a:mode is# 'v'
    normal! gv
  endif

  if g:smartbraces_spell && !&l:spell
    'normal! ' . v:count1 . '{'
  else
    let isEmptyCurline = (getline(line('.')) =~# '^\s*$')
    let isEmptyUpline  = (getline(line('.')-1) =~# '^\s*$')

    let counts = v:count1
    if isEmptyUpline && (!isEmptyCurline && col('.')-1 <= indent(line('.')))
      let counts += 1
    endif
    exe 'normal! ' . counts . '{'
    call search('^\s*\S', 'ecWz')
  endif
endfunction

function! smartbraces#CloseBrace(mode) abort
  if a:mode is# 'v'
    normal! gv
  endif

  if g:smartbraces_spell && !&l:spell
    'normal! ' . v:count1 . '{'
  else
    let isEmptyCurline     = (getline(line('.')) =~# '^\s*$')
    let isEmptyDownline    = (getline(line('.')+1) =~# '^\s*$')
    let isEmptyRestCurline = (getline('.')[col('.'):] =~# '^\s*$')

    let counts = v:count1
    if isEmptyDownline && (!isEmptyCurline && isEmptyRestCurline)
      let counts += 1
    endif
    exe 'normal! ' . counts . '}'
    call search('\S\s*$', 'bcWz')
  endif
endfunction

