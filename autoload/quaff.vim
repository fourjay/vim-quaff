let s:autoload_file_path = expand('<sfile>')
function! quaff#get_script_base()
    if exists('g:quaff_store_path')
        if exists(glob('g:quaff_store_path'))
            return g:quaff_store_path
        else
            echoerr g:quaff_store_path . ' does not appear to be valid, using default'
        endif
    endif
    let l:base = substitute( s:autoload_file_path, 'autoload/quaff.vim', '', '')
    return l:base
endfunction

function! quaff#ensure_dir()
    if empty(glob( quaff#get_script_base() ))
        echoerr 'quaff script seems deleted'
        return
    endif
    let l:dir = quaff#get_script_base() . 'annotations'
    if empty(glob( quaff#get_script_base() . 'annotations' ))
        echo 'making annotations directory'
        call mkdir( l:dir )
    endif
endfunction

function! quaff#get_stringpath()
    let l:actual_path = expand('%:p')
    let l:marshalled_path = substitute( l:actual_path, '[/\\]', '%', 'g')
    return l:marshalled_path
endfunction

function! quaff#get_qf_file()
    call quaff#ensure_dir()
    let l:partial_path = quaff#get_script_base() . 'annotations/' . quaff#get_stringpath() . '.qf'
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
    silent! execute 'cfile ' . l:escaped_path
    copen
    setlocal filetype+=.quaff
    execute 'update! ' . l:escaped_path
    setlocal modifiable
    " cleanup cfile artifacts
    silent global/^||[ |]*$/d
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
    if ! quaff#exists()
        call quaff#load()
    endif
    call quaff#make_note('ADD_NOTE')
    call quaff#go_to()
    call search('ADD_NOTE', '')
    resize +1
    normal! zb
    setlocal modifiable
    normal! viw
    call feedkeys("\<C-G>")
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
    if l:qf_buf == -1
        let l:qf_buf = bufnr( '[Quickfix List]')
    endif
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
