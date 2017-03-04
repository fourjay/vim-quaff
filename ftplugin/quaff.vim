setlocal modifiable
let b:is_quaff = 1

autocmd BufEnter <buffer> call quaff#jump_to_note()
autocmd BufLeave <buffer> update
