setlocal modifiable
let b:is_quaff = 1

if hasmapto( '<buffer> v')
    nunmap <buffer> v
    nunmap <buffer> q
endif

autocmd BufEnter,BufRead,BufWinEnter *.qf call quaff#jump_to_note()
autocmd BufLeave *.qf update
