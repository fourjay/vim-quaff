# vim-quaff
Use (abuse) quickfix to keep file level notes, with minimal fuss

This is inspired by qfedit, QFV. CodeReview.vim and a serveral other editable
QuickFix utilities. Unlike those plugins, this does not attempt to facilitate
search and replace. For that use I'd recommend romainl ``qf.vim`` as a clean
and vimlike version. Nor does it try to overlay code review functions on top of
the core technique.

# Features

* Minimal interface. Most functionality comes with one mapping
* Automatic storage persistance.
* Extends existing vim rather then implementing a separate layer

This plugin focuses on the simple use case of allowing ad-hoc quickfix lists.
It (minimally) extends vim's quickfix list's presentation format as a natural
mark listing format. Rather then editing in a separate (and third) micro
buffer, just edit the quickfix "message" field in place as a normal buffer.
