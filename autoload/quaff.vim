function! quaff#get_stringpath()
    let l:actual_path = expand('%:p')
    let l:marshalled_path = substitute( l:actual_path, '[/\\]', '%', 'g')
    return l:marshalled_path
endfunction

function! quaff#get_qf_file()
     let l:partial_path = g:quaff_store_path . '/' . quaff#get_stringpath() . '.qf'
     return expand( l:partial_path )
 endfunction

 function! quaff#ensure_file()
    let l:path = quaff#get_qf_file()
    if empty( glob(l:path) )
        call writefile([''], l:path)
    endif
 endfunction

function! quaff#load_qf()
    let l:compiler = b:current_compiler
    compiler quickfix
    let l:path = quaff#get_qf_file()
    let l:escaped_path = escape( l:path, '%' )
    call quaff#ensure_file()
    execute 'cfile ' . l:escaped_path
    copen
    setlocal filetype=qf.quaff
    execute 'write! ' . l:escaped_path
    if ! empty(l:compiler)
        execute 'compiler ' . l:compiler
    endif
endfunction

function quaff#add_note(note)
  let l:entry = {}
  " may need expand() here.
  let l:entry['filename'] = bufname('%')
  let l:entry['lnum'] = line('.')
  let l:entry['col'] = col('.')
  let l:entry['vcol'] = ''
  let l:entry['text'] = a:note
  let l:entry['type'] = 'E'
  call setqflist([l:entry], 'a')
endfunction

