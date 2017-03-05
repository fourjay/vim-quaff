command! Quaffopen call quaff#load()

nnoremap <Plug>QuaffNote :call quaff#add_note()<Cr>
if ! hasmapto('<Plug>QuaffNote')
    nmap <unique> m; <Plug>QuaffNote
endif
