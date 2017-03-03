setlocal modifiable

autocmd BufEnter <buffer> call quaff#jump_to_note()
autocmd BufLeave <buffer> update
