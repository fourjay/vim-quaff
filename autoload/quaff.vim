function! quaff#get_stringpath()
    let l:actual_path = expand('%:p')
    let l:marshalled_path = substitute( l:actual_path, '[/\\]', '%', 'g')
    return l:marshalled_path
endfunction

function! quaff#get_qf_file()
     return g:quaff_store_path . '/' . quaff#get_stringpath()
 endfunction

function! quaff#load_qf()
    let l:compiler = b:current_compiler
    compiler quickfix
    let l:path = quaff#get_qf_file()
    if empty( glob(l:path) )
        call writefile([''], l:path)
    endif
    cfile l:path
    copen
    execute 'write ' . quaff#get_qf_file()
    execute 'compiler ' . l:compiler
endfunction

