.PHONY: all
all: config install

.PHONY: config
config: config/kitty/gruvbox.conf ~/.tmux.conf ~/.zshrc ~/.config/nvim ~/.config/kitty git ~/.local/bin/git-diff-wrapper ~/.local/bin/tmux-sessionizer ~/.config/bat
	mkdir -p ~/.local/bin/
	mkdir -p ~/.config/
	
.PHONY: install
install: brew oh-my-zsh py3-nvim fzf
	

.PHONY: brew
brew:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew bundle

.PHONY: oh-my-zsh
oh-my-zsh:
	sh -c "$$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/jeffreytse/zsh-vi-mode "$${ZSH_CUSTOM}/plugins/zsh-vi-mode"
	git clone https://github.com/zsh-users/zsh-autosuggestions "$${ZSH_CUSTOM}/plugins/zsh-autosuggestions"

.PHONY: py3-nvim
py3-nvim:
	python3 -m pip install --user --upgrade pynvim

.PHONY: fzf
fzf:
	$$(brew --prefix)/opt/fzf/install --no-update-rc --completion --key-bindings

~/.local/bin/git-diff-wrapper:
	ln -s $$PWD/bin/git-diff-wrapper ~/.local/bin/git-diff-wrapper

~/.local/bin/tmux-sessionizer:
	ln -s $$PWD/bin/tmux-sessionizer ~/.local/bin/tmux-sessionizer

config/kitty/gruvbox.conf:
	curl https://raw.githubusercontent.com/dexpota/kitty-themes/master/themes/gruvbox_dark.conf -o config/kitty/gruvbox.conf

~/.tmux.conf:
	ln -s $$PWD/tmux.conf ~/.tmux.conf

~/.zshrc:
	ln -s $$PWD/zshrc ~/.zshrc

~/.config/nvim:
	ln -s $$PWD/config/nvim/ ~/.config/nvim

~/.config/bat:
	ln -s $$PWD/config/bat/ ~/.config/bat

~/.config/kitty:
	ln -s $$PWD/config/kitty/ ~/.config/kitty

~/.vim/UltiSnips/all.snippets:
	mkdir -p ~/.vim/UltiSnips/
	ln -s $$PWD/all.snippets ~/.vim/UltiSnips/

.PHONY: git
git:
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

.PHONY: clean
clean:
	rm -f config/kitty/gruvbox.conf ~/.tmux.conf ~/.zshrc ~/.config/nvim ~/.config/kitty ~/.local/bin/git-diff-wrapper ~/.local/bin/tmux-sessionizer

