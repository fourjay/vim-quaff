function! quaff#get_stringpath()
    let l:actual_path = expand('%:p')
    let l:actual_path = substitute( l:actual_path, '[/\\]', '%', 'g')
    return l:actual_path
endfunction
