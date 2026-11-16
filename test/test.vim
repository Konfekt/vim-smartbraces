" Headless tests for vim-smartbraces. Run with test/run.sh.
scriptencoding utf-8
let s:root = fnamemodify(expand('<sfile>:p'), ':h:h')
let &runtimepath = s:root . ',' . &runtimepath
execute 'source' fnameescape(s:root . '/plugin/smartbraces.vim')
set report=9999

let s:text = [
      \ 'one two.',
      \ 'three four.',
      \ '',
      \ 'five six.',
      \ 'seven eight.',
      \ '',
      \ 'nine ten.',
      \ ]

function! s:buf(lines, lnum, col) abort
  enew!
  setlocal nospell
  let g:smartbraces_spell = 0
  call setline(1, a:lines)
  call cursor(a:lnum, a:col)
endfunction

" Type keys with mappings, as a user does.
function! s:keys(keys) abort
  execute 'normal ' . a:keys
endfunction

function! s:pos() abort
  return [line('.'), col('.')]
endfunction

function! Test_close_brace_end_of_paragraph() abort
  call s:buf(s:text, 1, 1)
  call s:keys('}')
  call assert_equal([2, 11], s:pos())
  " from the end of a paragraph, jump to the end of the next one
  call s:keys('}')
  call assert_equal([5, 12], s:pos())
  call s:keys('2{')
  call assert_equal([1, 1], s:pos())
endfunction

function! Test_open_brace_start_of_paragraph() abort
  call s:buf(s:text, 5, 4)
  call s:keys('{')
  call assert_equal([4, 1], s:pos())
  " from the start of a paragraph, jump to the start of the previous one
  call s:keys('{')
  call assert_equal([1, 1], s:pos())
endfunction

function! Test_close_brace_count() abort
  call s:buf(s:text, 1, 1)
  call s:keys('2}')
  call assert_equal([5, 12], s:pos())
endfunction

function! Test_close_parenthesis_end_of_sentence() abort
  call s:buf(['One two. Three four. Five.'], 1, 1)
  call s:keys(')')
  call assert_equal([1, 8], s:pos())
  call s:keys(')')
  call assert_equal([1, 20], s:pos())
  call cursor(1, 1)
  call s:keys('2)')
  call assert_equal([1, 20], s:pos())
endfunction

function! Test_visual_close_brace() abort
  call s:buf(s:text, 1, 1)
  call s:keys('v}y')
  call assert_equal("one two.\nthree four.", @")
endfunction

function! Test_operator_close_brace() abort
  call s:buf(s:text, 1, 1)
  call s:keys('d}')
  call assert_equal(['', '', 'five six.'], getline(1, 3))
endfunction

function! Test_operator_close_brace_count() abort
  call s:buf(s:text, 1, 1)
  call s:keys('d2}')
  call assert_equal(['', '', 'nine ten.'], getline(1, 3))
endfunction

function! Test_default_operator_mappings() abort
  for [s:name, s:key] in [['OpenBrace', '{'], ['CloseBrace', '}'], ['CloseParenthesis', ')']]
    for s:mode in ['n', 'x', 'o']
      call assert_equal('<Plug>(smartbraces-' . s:name . ')', maparg(s:key, s:mode), s:mode . 'map ' . s:key)
    endfor
  endfor
endfunction

function! Test_operator_close_parenthesis() abort
  call s:buf(['One two. Three four. Five.'], 1, 1)
  call s:keys('d)')
  call assert_equal(' Three four. Five.', getline(1))
  call assert_equal('One two.', @")
endfunction

function! Test_operator_open_brace() abort
  call s:buf(s:text, 5, 7)
  call s:keys('d{')
  call assert_equal(['', 'eight.'], getline(3, 4))
endfunction

function! Test_operator_close_parenthesis_count() abort
  call s:buf(['One two. Three four. Five.'], 1, 1)
  call s:keys('d2)')
  call assert_equal(' Five.', getline(1))
endfunction

function! Test_visual_close_brace_count() abort
  call s:buf(s:text, 1, 1)
  call s:keys('v2}y')
  call assert_equal("one two.\nthree four.\n\nfive six.\nseven eight.", @")
endfunction

" With g:smartbraces_spell set, the keys behave natively in buffers without
" spell checking.
function! Test_spell_option_falls_back_to_native() abort
  call s:buf(s:text, 1, 1)
  let g:smartbraces_spell = 1
  call s:keys('}')
  call assert_equal([3, 1], s:pos())
  call s:keys('{')
  call assert_equal([1, 1], s:pos())
  call s:buf(['One two. Three four.'], 1, 1)
  let g:smartbraces_spell = 1
  call s:keys(')')
  call assert_equal([1, 10], s:pos())
  let g:smartbraces_spell = 0
endfunction

" A multibyte character under the cursor at the end of a paragraph.
function! Test_close_brace_multibyte_end_of_line() abort
  call s:buf(['un café', '', 'deux thé', 'trois', '', 'x'], 1, 1)
  call s:keys('}')
  call assert_equal(1, line('.'))
  call assert_equal('é', matchstr(getline('.'), '\%' . col('.') . 'c.'))
  call s:keys('}')
  call assert_equal([4, 5], s:pos())
endfunction

" Tab indentation: from inside the first line, { goes to the start of the
" current paragraph, not of the previous one.
function! Test_open_brace_tab_indent() abort
  call s:buf(['a', '', "\tfoo bar baz", "\tqux"], 4, 3)
  call s:keys('{')
  call assert_equal([3, 2], s:pos())
  call cursor(3, 4)
  call s:keys('{')
  call assert_equal([3, 2], s:pos())
endfunction

" Runner
let s:failed = 0
let s:out = []
for s:t in sort(filter(map(split(execute('function /^Test_'), "\n"), 'matchstr(v:val, ''Test_\w\+'')'), '!empty(v:val)'))
  let v:errors = []
  try
    execute 'call ' . s:t . '()'
  catch
    call add(v:errors, s:t . ': ' . v:exception . ' @ ' . v:throwpoint)
  endtry
  if empty(v:errors)
    call add(s:out, 'ok   ' . s:t)
  else
    let s:failed += 1
    call extend(s:out, ['FAIL ' . s:t] + v:errors)
  endif
endfor
call add(s:out, s:failed ? s:failed . ' test(s) failed' : 'all tests passed')
call writefile(s:out, $SMARTBRACES_TEST_LOG)
execute (s:failed ? 'cquit!' : 'qall!')
