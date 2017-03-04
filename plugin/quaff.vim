let g:quaff_store_path = '~/tmp/.vim/qf'

command! QQ call quaff#load()
command! Qq call quaff#load()

command! QN call quaff#load()
command! Qn call quaff#add_note()

nnoremap m; :call quaff#add_note()<Cr>
