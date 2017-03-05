command! QQ call quaff#load()
command! Qq call quaff#load()

command! QN call quaff#load()
command! Qn call quaff#add_note()

nnoremap <Plug>QuaffNote :call quaff#add_note()<Cr>
if ! hasmapto('<Plug>QuaffNote')
    nmap <unique> m; <Plug>QuaffNote
endif
