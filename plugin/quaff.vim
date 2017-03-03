let g:quaff_store_path = '~/tmp/.vim/qf'

command! QQ call quaff#load_qf()
command! Qq call quaff#load_qf()

command! QN call quaff#load_qf()

command! Qn call quaff#add_note('')
