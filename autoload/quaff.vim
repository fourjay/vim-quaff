function! quaff#get_stringpath()
    let l:actual_path = expand('%:p')
    let l:marshalled_path = substitute( l:actual_path, '[/\\]', '%', 'g')
    return l:marshalled_path
endfunction

function! quaff#get_qf_file()
     let l:partial_path = g:quaff_store_path . '/' . quaff#get_stringpath() . '.qf'
     return expand( l:partial_path )
 endfunction

function! quaff#get_qf_escaped_file()
     return escape( quaff#get_qf_file(), '%' ) 
 endfunction

 function! quaff#ensure_file()
    let l:path = quaff#get_qf_file()
    if empty( glob(l:path) )
        call writefile([''], l:path)
    endif
 endfunction

function! quaff#load_qf()
    let l:escaped_path = quaff#get_qf_escaped_file()
    call quaff#ensure_file()
    if exists('b:current_compiler')
        let l:compiler = b:current_compiler
    endif
    compiler quickfix
    silent execute 'cfile ' . l:escaped_path
    copen
    execute 'write! ' . l:escaped_path
    setlocal filetype=qf.quaff
    " restore if it was set
    if exists('l:compiler')
        execute 'compiler ' . l:compiler
    endif
    wincmd w
endfunction

function! quaff#add_note(note)
  let l:entry = {}
  " may need expand() here.
  let l:entry['filename'] = bufname('%')
  let l:entry['lnum'] = line('.')
  let l:entry['col'] = col('.')
  let l:entry['vcol'] = ''
  let l:entry['text'] = a:note
  call setqflist([l:entry], 'a')
  copen
  write!
  wincmd w
endfunction

" Jump to 'editable' section
function! quaff#jump_to_note()
    call search('| \zs[^|]*', 'c')
endfunction
