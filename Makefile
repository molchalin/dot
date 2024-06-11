.PHONY: all
all: config install

.PHONY: config
config: configdir config/kitty/gruvbox.conf ~/.tmux.conf ~/.zshrc ~/.config/nvim ~/.config/kitty ~/.config/karabiner git ~/.local/bin/git-diff-wrapper ~/.local/bin/tmux-sessionizer ~/.local/bin/notes ~/.config/bat

.PHONY: configdir
configdir:
	mkdir -p ~/.local/bin/
	mkdir -p ~/.config/

	
.PHONY: install
install: brew oh-my-zsh fzf nvim-spell-ru
	

.PHONY: brew
brew:
	#/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	#TODO
	#(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/aeremeev/.zprofile eval "$(/opt/homebrew/bin/brew shellenv)"
	brew bundle

.PHONY: oh-my-zsh
oh-my-zsh:
	ZSH_CUSTOM = ${ZSH_CUSTOM}
	# sh -c "$$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/jeffreytse/zsh-vi-mode "${ZSH_CUSTOM}/plugins/zsh-vi-mode"
	git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
	git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/fast-syntax-highlighting"
	git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "${ZSH_CUSTOM}/plugins/you-should-use"
	git clone https://github.com/MichaelAquilina/zsh-auto-notify.git "${ZSH_CUSTOM}/plugins/auto-notify"



.PHONE: nvim-spell-ru
nvim-spell-ru:
	mkdir -p ~/.local/share/nvim/site/spell
	curl 'http://ftp.vim.org/pub/vim/runtime/spell/ru.utf-8.spl' -o ~/.local/share/nvim/site/spell/ru.utf-8.spl
	curl 'http://ftp.vim.org/pub/vim/runtime/spell/de.utf-8.spl' -o ~/.local/share/nvim/site/spell/de.utf-8.spl

.PHONY: fzf
fzf:
	$$(brew --prefix)/opt/fzf/install --no-update-rc --completion --key-bindings

~/.local/bin/git-diff-wrapper:
	ln -s $$PWD/bin/git-diff-wrapper ~/.local/bin/git-diff-wrapper

~/.local/bin/tmux-sessionizer:
	ln -s $$PWD/bin/tmux-sessionizer ~/.local/bin/tmux-sessionizer

~/.local/bin/notes:
	ln -s $$PWD/bin/notes ~/.local/bin/notes

~/.local/bin/breakfree:
	ln -s $$PWD/bin/breakfree ~/.local/bin/breakfree

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

~/.config/karabiner:
	ln -s $$PWD/config/karabiner/ ~/.config/karabiner


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
	rm -f config/kitty/gruvbox.conf ~/.tmux.conf ~/.zshrc ~/.config/nvim ~/.config/kitty ~/.local/bin/git-diff-wrapper ~/.local/bin/tmux-sessionizer ~/.local/bin/notes ~/.local/bin/breakfree

