.PHONY: all
all: install files stow bat-cache oh-my-zsh

.PHONY: install
install: brew git fzf

.PHONY: files
files: spell config/kitty/gruvbox-material-dark-medium.conf config/bat/themes/gruvbox-material-dark.tmTheme bin/gocryptfs

.PHONY: stow
stow:
	mkdir -p ~/.local/bin
	mkdir -p ~/.config/
	mkdir -p ~/.local/share/nvim/site/spell
	ln -s $$PWD/config/zshrc ~/.zshrc
	ln -s $$PWD/config/tmux.conf ~/.tmux.conf
	fd . bin --absolute-path --max-depth 1 --exec ln -s {} ~/.local/bin/{/}
	fd . share/nvim/site/spell --absolute-path --max-depth 1 --exec ln -s {} ~/.local/share/nvim/site/spell/{/}
	fd . config --type d --absolute-path --max-depth 1 --exec ln -s {} ~/.config/{/}

BREW := $(shell which brew 2> /dev/null)

.PHONY: brew
brew:
ifndef BREW
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/aeremeev/.zprofile eval "$(/opt/homebrew/bin/brew shellenv)"
endif
	brew bundle --no-upgrade

.PHONY: oh-my-zsh
oh-my-zsh: stow
	# sh -c "$$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/jeffreytse/zsh-vi-mode "${ZSH_CUSTOM}/plugins/zsh-vi-mode"
	git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
	git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/fast-syntax-highlighting"
	git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "${ZSH_CUSTOM}/plugins/you-should-use"
	git clone https://github.com/MichaelAquilina/zsh-auto-notify.git "${ZSH_CUSTOM}/plugins/auto-notify"

spell:
	mkdir -p share/nvim/site/spell
	curl 'http://ftp.vim.org/pub/vim/runtime/spell/ru.utf-8.spl' -o share/nvim/site/spell/ru.utf-8.spl
	curl 'http://ftp.vim.org/pub/vim/runtime/spell/de.utf-8.spl' -o share/nvim/site/spell/de.utf-8.spl

.PHONY: fzf
fzf: brew
	$$(brew --prefix)/opt/fzf/install --no-update-rc --completion --key-bindings

config/kitty/gruvbox-material-dark-medium.conf:
	curl https://raw.githubusercontent.com/selenebun/gruvbox-material-kitty/main/colors/gruvbox-material-dark-medium.conf -o config/kitty/gruvbox-material-dark-medium.conf

config/bat/themes/gruvbox-material-dark.tmTheme:
	mkdir -p config/bat/themes
	curl https://raw.githubusercontent.com/molchalin/gruvbox-material-bat/main/gruvbox-material-dark.tmTheme -o config/bat/themes/gruvbox-material-dark.tmTheme

.PHONY: bat-cache
bat-cache: brew stow
	bat cache --build


.PHONY: git
git:
	git config --global user.name "Andrei Eremeev"
	git config --global core.pager "delta"
	git config --global interactive.diffFilter "delta --color-only"
	git config --global delta.syntax-theme "gruvbox-material-dark"
	git config --global delta.side-by-side "true"
	git config --global delta.file-style "bold yellow"
	git config --global delta.file-decoration-style "none"
	git config --global delta.hunk-header-decoration-style "none"
	git config --global merge.conflictstyle "diff3"
	git config --global diff.colorMoved "default"

bin/gocryptfs: brew
	git clone https://github.com/rfjakob/gocryptfs.git /tmp/gocryptfs && \
	pushd /tmp/gocryptfs && \
	./build-without-openssl.bash && \
	popd && \
	mv /tmp/gocryptfs/gocryptfs bin/gocryptfs && \
	rm -rf /tmp/gocryptfs


.PHONY: clean
clean:
	rm -f ~/.zshrc
	rm -f ~/.tmux.conf
	fd . bin --absolute-path --max-depth 1 --exec rm ~/.local/bin/{/}
	fd . share/nvim/site/spell --absolute-path --max-depth 1 --exec rm ~/.local/share/nvim/site/spell/{/}
	fd . config --absolute-path --max-depth 1 --type d --exec rm ~/.config/{/}
	rm -f  share/nvim/site/spell/* config/kitty/gruvbox.conf config/bat/themes/gruvbox-material-dark.tmTheme bin/gocryptfs
