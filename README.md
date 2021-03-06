This Vim plug-in makes

- the keys `{` and `}` jump to the beginning respectively to the end of the current paragraph (instead of the first empty line before respectively after it, by default), and
- the key `)` jump to the end of the current sentence (instead of the   start of the next sentence).

# Setup

If you prefer to use different key combinations instead, say `g{`, `g}` and `g)`, add

```vim
nmap  g{  <Plug>(smartbraces-OpenBrace)
nmap  g}  <Plug>(smartbraces-CloseBrace)
xmap  g{  <Plug>(smartbraces-OpenBrace)
xmap  g}  <Plug>(smartbraces-CloseBrace)
omap  g{  <Plug>(smartbraces-OpenBrace)
omap  g}  <Plug>(smartbraces-CloseBrace)

nmap  g)  <Plug>(smartbraces-CloseParenthesis)
xmap  g)  <Plug>(smartbraces-CloseParenthesis)
omap  g)  <Plug>(smartbraces-CloseParenthesis)
```

to your `vimrc`.

If you prefer that the keys `{` and `},` as well as `),` jump to the beginning respectively to the end of the current paragraph, respectively sentence, only inside spellchecked buffers, but work as usual otherwise, add

```vim
  let g:smartbraces_spell = 1
```

to your `vimrc`.

