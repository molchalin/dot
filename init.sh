ln -s $PWD/.tmux.conf ~/.tmux.conf
ln -s $PWD/.zshrc ~/.zshrc

ln -s $PWD/git_diff_wrapper ~/.git_diff_wrapper
ln -s $PWD/tmux-sessionizer ~/.tmux-sessionizer

mkdir -p ~/.config/
ln -s $PWD/config/nvim/ ~/.config/nvim

mkdir -p ~/.vim/UltiSnips/
ln -s $PWD/all.snippets ~/.vim/UltiSnips/




git config --global user.name "Andrei Eremeev"
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.syntax-theme "gruvbox-dark"
git config --global delta.side-by-side "true"
git config --global delta.file-style "bold yellow"
git config --global delta.file-decoration-style "none"
git config --global delta.hunk-header-decoration-style "none"
git config --global merge.conflictstyle "diff3"
git config --global diff.colorMoved "default"
