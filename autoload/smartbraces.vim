function! smartbraces#OpenBrace(vm) abort
  if a:vm
    normal! gv
  endif

  let curline = line('.')
  let upline = (foldclosed(curline-1) isnot -1 ? foldclosed(curline-1) : curline) - 1
  let isEmptyUpline = getline( upline ) =~# '^\s*$'
  if isEmptyUpline
    if getline(line('.')-1) =~# '^\s*$' && col('.') >= col('$')-1
      normal! ^
      return
    endif

    normal! {
    if line('.') is 1
      normal! ^
    elseif !search('\S\s*$', 'bW')
      normal! +^
    endif
  else
    normal! {
    call search('^\s*\S', 'ecW')
  endif
endfunction

function! smartbraces#CloseBrace(vm) abort
  if a:vm
    normal! gv
  endif

  let curline = line('.')
  let downline = (foldclosed(curline+1) isnot -1 ? foldclosedend(curline+1) : curline) + 1
  let isEmptyDownline = getline( downline ) =~# '^\s*$'
  if isEmptyDownline
    let curcol = col('.')
    if getline(line('.')-1) =~# '^\s*$' && (curcol == 1 || curcol <= indent('.') + 1) 
      normal! g_
      return
    endif

    normal! }
    if line('.') is line('$')
      normal! g_
    elseif !search('^\s*\S', 'eW')
      normal! -g_
    endif
  else
    normal! }
    call search('\S\s*$', 'bcW')
  endif
endfunction

