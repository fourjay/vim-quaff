" setup known state
if exists('g:did_quaff') 
      " \ || &compatible 
      " \ || version < 700}
    finish
endif
let g:did_quaff = '1'
let s:save_cpo = &cpoptions
set cpoptions&vim

command! Quaffopen call quaff#load()

nnoremap <Plug>QuaffNote :call quaff#add_note()<Cr>
if ! hasmapto('<Plug>QuaffNote')
    nmap <unique> m; <Plug>QuaffNote
endif

" Return vim to users choice
let &cpoptions = s:save_cpo
