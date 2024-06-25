.PHONY: install
install: brew oh-my-zsh fzf bin/gocryptfs

.PHONY: configure
configure: spell config/kitty/gruvbox-material-dark-medium.conf config/bat/themes/gruvbox-material-dark.tmTheme

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
	(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/aeremeev/.zprofile 
	eval "$(/opt/homebrew/bin/brew shellenv)"
endif
	brew bundle --no-upgrade

OMZ := $(shell ls ~/.oh-my-zsh 2> /dev/null)
.PHONY: oh-my-zsh
oh-my-zsh:
ifndef OMZ
	RUNZSH=no sh -c "$$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/jeffreytse/zsh-vi-mode "$$HOME/.oh-my-zsh/plugins/zsh-vi-mode"
	git clone https://github.com/zsh-users/zsh-autosuggestions "$$HOME/.oh-my-zsh/plugins/zsh-autosuggestions"
	git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$$HOME/.oh-my-zsh/plugins/fast-syntax-highlighting"
	git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$$HOME/.oh-my-zsh/plugins/you-should-use"
	git clone https://github.com/MichaelAquilina/zsh-auto-notify.git "$$HOME/.oh-my-zsh/plugins/auto-notify"
	rm ~/.zshrc
endif

spell:
	mkdir -p share/nvim/site/spell
	curl 'http://ftp.vim.org/pub/vim/runtime/spell/ru.utf-8.spl' -o share/nvim/site/spell/ru.utf-8.spl
	curl 'http://ftp.vim.org/pub/vim/runtime/spell/de.utf-8.spl' -o share/nvim/site/spell/de.utf-8.spl

.PHONY: fzf
fzf:
	$$(brew --prefix)/opt/fzf/install --no-update-rc --completion --key-bindings

config/kitty/gruvbox-material-dark-medium.conf:
	curl https://raw.githubusercontent.com/selenebun/gruvbox-material-kitty/main/colors/gruvbox-material-dark-medium.conf -o config/kitty/gruvbox-material-dark-medium.conf

config/bat/themes/gruvbox-material-dark.tmTheme:
	mkdir -p config/bat/themes
	curl https://raw.githubusercontent.com/molchalin/gruvbox-material-bat/main/gruvbox-material-dark.tmTheme -o config/bat/themes/gruvbox-material-dark.tmTheme

.PHONY: bat-cache
bat-cache:
	bat cache --build

bin/gocryptfs:
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
	fd . bin --absolute-path --max-depth 1 --exec rm -f ~/.local/bin/{/}
	fd . share/nvim/site/spell --absolute-path --max-depth 1 --exec rm -f ~/.local/share/nvim/site/spell/{/}
	fd . config --absolute-path --max-depth 1 --type d --exec rm -f ~/.config/{/}
	rm -f  share/nvim/site/spell/* config/kitty/gruvbox.conf config/bat/themes/gruvbox-material-dark.tmTheme bin/gocryptfs
