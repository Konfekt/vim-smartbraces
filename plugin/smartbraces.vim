scriptencoding utf-8

" LICENCE PUBLIQUE RIEN À BRANLER
" Version 1, Mars 2009
"
" Copyright (C) 2009 Sam Hocevar
" 14 rue de Plaisance, 75014 Paris, France
"
" La copie et la distribution de copies exactes de cette licence sont
" autorisées, et toute modification est permise à condition de changer
" le nom de la licence.
"
" CONDITIONS DE COPIE, DISTRIBUTON ET MODIFICATION
" DE LA LICENCE PUBLIQUE RIEN À BRANLER
"
" 0. Faites ce que vous voulez, j'en ai RIEN À BRANLER.

if exists('g:loaded_smartbraces')
  finish
endif
let g:loaded_smartbraces = 1

let s:keepcpo = &cpoptions
set cpoptions&vim
" ------------------------------------------------------------------------------

if !exists('g:smartbraces_spell')
  let g:smartbraces_spell = 0
endif

for [s:name, s:key] in [['OpenBrace', '{'], ['CloseBrace', '}'], ['CloseParenthesis', ')']]
  let s:plug = '<Plug>(smartbraces-' . s:name . ')'
  for s:mode in ['n', 'x', 'o']
    execute printf('%snoremap <silent> %s :<C-U>%scall smartbraces#%s(%s)<CR>',
          \ s:mode, s:plug, s:mode is# 'o' ? 'keepjumps ' : '', s:name, string(s:mode))
    if !hasmapto(s:plug, s:mode)
      execute 'silent! ' . s:mode . 'map <unique> ' . s:key . ' ' . s:plug
    endif
  endfor
endfor
unlet s:name s:key s:plug s:mode

" ------------------------------------------------------------------------------
let &cpoptions = s:keepcpo
unlet s:keepcpo
