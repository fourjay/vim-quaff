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

function! quaff#load()
    if quaff#exists()
        echom 'exists'
        return
    endif
    let l:escaped_path = quaff#get_qf_escaped_file()
    call quaff#ensure_file()
    if exists('b:current_compiler')
        let l:compiler = b:current_compiler
    endif
    compiler quickfix
    silent execute 'cfile ' . l:escaped_path
    copen
    setlocal filetype+=.quaff
    execute 'write! ' . l:escaped_path
    setlocal modifiable
    " restore if it was set
    if exists('l:compiler')
        execute 'compiler ' . l:compiler
    endif
    wincmd w
endfunction

function! quaff#make_note(note)
    if ! quaff#exists()
        call quaff#load()
    endif
    let l:entry = {}
    " may need expand() here.
    let l:entry['filename'] = bufname('%')
    let l:entry['lnum'] = line('.')
    let l:entry['col'] = col('.')
    let l:entry['vcol'] = ''
    let l:entry['text'] = a:note
    call setqflist([l:entry], 'a')
endfunction

function! quaff#add_note()
    echom 'got called'
    if ! quaff#exists()
        call quaff#load()
    endif
    call quaff#make_note('ADDNOTE')
    call quaff#go_to()
    " write!
    " wincmd w
endfunction

function! quaff#exists()
    if quaff#nr() == -1
        return
    else
        return 1
    endif
endfunction

function! quaff#nr()
    return bufnr( expand('%:t') . '.qf' )
endfunction

function! quaff#go_to()
    if exists('b:is_quaff')
        return
    endif
    let l:qf_buf = bufnr( expand('%:t') . '.qf' )
    execute l:qf_buf . 'wincmd w'
endfunction

function! quaff#go_to_main()
    if ! exists('b:is_quaff')
        return
    endif
    let l:qf_name = substitute(expand('%:t'), '.*%', '', '')
    let l:main_buf = substitute( l:qf_name, '.qf$', '', '')
    let l:qf_buf = bufnr( l:main_buf . '$' )
    execute l:qf_buf . 'wincmd w'
endfunction

" Jump to 'editable' section
function! quaff#jump_to_note()
    call search('| \zs[^|]*', 'c')
endfunction
