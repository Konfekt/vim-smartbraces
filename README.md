This Vim plug-in makes

- the keys `{` and `}` jump to the beginning respectively to the end of the current paragraph (instead of the first empty line before respectively after it, by default), and
- the key `)` jump to the end of the current sentence (instead of the start of the next sentence).

Pressed again at the beginning (or end) of a paragraph, `{` (or `}`) jumps to the beginning (or end) of the previous (or next) paragraph.
Counts work in Normal, Visual and Operator-pending mode.
A sentence ends at a `.`, `!` or `?`, followed by any closing `)`, `]`, `"` or `'`, and then a space, a tab or the end of the line; as for Vim's own sentence motions, the end of a paragraph also ends a sentence.
After an operator, `}` and `)` include the last character of the paragraph or sentence, so that, for example, `d)` deletes the rest of the current sentence up to and including its final punctuation mark.

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
To keep the native behavior of a key in one mode, map it to itself, for example `onoremap } }` to keep `d}` as it is.

If you prefer that the keys `{` and `}`, as well as `)`, jump to the beginning respectively to the end of the current paragraph, respectively sentence, only inside spellchecked buffers, but work as usual otherwise, add

```vim
let g:smartbraces_spell = 1
```

to your `vimrc`.

# Tests

Run `test/run.sh` to run the headless test suite in Vim and Neovim.
