function! smartbraces#OpenBrace(vm) abort
  if a:vm
    normal! gv
  endif

  let curline = line('.')
  let upline = (foldclosed(curline-1) isnot -1 ? foldclosed(curline-1) : curline) - 1
  let isEmptyUpline = getline( upline ) =~# '^\s*$'
  if isEmptyUpline
    let isEmptyDownline = getline(curline+1) =~# '^\s*$'
    if isEmptyDownline && col('.')-1 > indent(curline)
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
  let isEmptyDownline = getline(downline) =~# '^\s*$'
  if isEmptyDownline
    let isEmptyUpline = getline(curline-1) =~# '^\s*$'
    let isEmptyRestline = getline('.')[col('.'):] =~# '^\s*$'
    if isEmptyUpline && !isEmptyRestline
          " \ && foldclosed(curline) isnot -1
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

