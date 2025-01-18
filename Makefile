.PHONY: install
install: brew oh-my-zsh fzf bin/gocryptfs

.PHONY: configure
configure: config/kitty/gruvbox-material-dark-medium.conf config/bat/themes/gruvbox-material-dark.tmTheme

.PHONY: stow
stow:
	mkdir -p ~/.local/bin
	mkdir -p ~/.config/
	ln -s $$PWD/config/zshrc ~/.zshrc
	fd . bin --absolute-path --max-depth 1 --exec ln -s {} ~/.local/bin/{/}
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

.PHONY: fzf
fzf:
	$$(brew --prefix)/opt/fzf/install --no-update-rc --completion --key-bindings

config/kitty/gruvbox-material-dark-medium.conf:
	kitten themes --dump-theme 'Gruvbox Material Dark Medium' > config/kitty/gruvbox-material-dark-medium.conf

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
	fd . bin --absolute-path --max-depth 1 --exec rm -f ~/.local/bin/{/}
	fd . config --absolute-path --max-depth 1 --type d --exec rm -f ~/.config/{/}
