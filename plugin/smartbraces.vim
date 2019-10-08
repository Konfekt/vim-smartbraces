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
" 0. Faites ce que vous voulez, j’en ai RIEN À BRANLER.

if exists('g:loaded_smartbraces')
  finish
endif
let g:loaded_smartbraces = 1

let s:keepcpo         = &cpo
set cpo&vim
" ------------------------------------------------------------------------------

if !exists('g:smartbraces_spell')
  let g:smartbraces_spell = 0
endif

nnoremap <silent> <Plug>(smartbraces-OpenBrace)  :<c-u>call smartbraces#OpenBrace('n')<cr>
nnoremap <silent> <Plug>(smartbraces-CloseBrace) :<c-u>call smartbraces#CloseBrace('n')<cr>
xnoremap <silent> <Plug>(smartbraces-OpenBrace)  :<c-u>call smartbraces#OpenBrace('v')<cr>
xnoremap <silent> <Plug>(smartbraces-CloseBrace) :<c-u>call smartbraces#CloseBrace('v')<cr>

nnoremap <silent> <SID>(v) v

onoremap <silent> <Plug>(smartbraces-OpenBrace)  :<c-u>exe "keepjumps normal \<SID>(v)\<Plug>(smartbraces-OpenBrace)"<CR>
onoremap <silent> <Plug>(smartbraces-CloseBrace)  :<c-u>exe "keepjumps normal \<SID>(v)\<Plug>(smartbraces-CloseBrace)"<CR>

if !hasmapto('<Plug>(smartbraces-OpenBrace)', 'n')
  silent! nmap <unique> {  <Plug>(smartbraces-OpenBrace)
endif
if !hasmapto('<Plug>(smartbraces-CloseBrace)', 'n')
  silent! nmap <unique> }  <Plug>(smartbraces-CloseBrace)
endif
if !hasmapto('<Plug>(smartbraces-OpenBrace)', 'x')
  silent! xmap <unique> {  <Plug>(smartbraces-OpenBrace)
endif
if !hasmapto('<Plug>(smartbraces-CloseBrace)', 'x')
  silent! xmap <unique> }  <Plug>(smartbraces-CloseBrace)
endif
if !hasmapto('<Plug>(smartbraces-OpenBrace)', 'o')
  silent! omap <unique> {  <Plug>(smartbraces-OpenBrace)
endif
if !hasmapto('<Plug>(smartbraces-CloseBrace)', 'o')
  silent! omap <unique> }  <Plug>(smartbraces-CloseBrace)
endif

" ------------------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo
