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

nnoremap <silent> <Plug>(smartbraces-OpenBrace)  :<c-u>call smartbraces#OpenBrace('n')<cr>
nnoremap <silent> <Plug>(smartbraces-CloseBrace) :<c-u>call smartbraces#CloseBrace('n')<cr>
xnoremap <silent> <Plug>(smartbraces-OpenBrace)  :<c-u>call smartbraces#OpenBrace('v')<cr>
xnoremap <silent> <Plug>(smartbraces-CloseBrace) :<c-u>call smartbraces#CloseBrace('v')<cr>

nnoremap <silent> <SID>(v) v

onoremap <silent> <Plug>(smartbraces-OpenBrace)  :<c-u>exe "keepjumps normal \<SID>(v)\<Plug>(smartbraces-OpenBrace)"<CR>
onoremap <silent> <Plug>(smartbraces-CloseBrace)  :<c-u>exe "keepjumps normal \<SID>(v)\<Plug>(smartbraces-CloseBrace)"<CR>

silent! nmap <unique> {  <Plug>(smartbraces-OpenBrace)
silent! nmap <unique> }  <Plug>(smartbraces-CloseBrace)
silent! xmap <unique> {  <Plug>(smartbraces-OpenBrace)
silent! xmap <unique> }  <Plug>(smartbraces-CloseBrace)
silent! omap <unique> {  <Plug>(smartbraces-OpenBrace)
silent! omap <unique> }  <Plug>(smartbraces-CloseBrace)

" ------------------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo
