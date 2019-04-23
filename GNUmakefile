.PHONY: clean install


install: ~/.bashrc ~/.vimrc ~/.vim ~/.dir_colors ~/.gitconfig ~/.tmux.conf

~/.bashrc:
	ln -s $(CURDIR)/bashrc ~/.bashrc

~/.vimrc:
	ln -s $(CURDIR)/vimrc ~/.vimrc

~/.vim:
	ln -s $(CURDIR)/vim ~/.vim

~/.dir_colors:
	ln -s $(CURDIR)/dircolors/dircolors.ansi-dark ~/.dir_colors

~/.gitconfig:
	ln -s $(CURDIR)/gitconfig ~/.gitconfig

~/.tmux.conf:
	ln -s $(CURDIR)/tmux.conf ~/.tmux.conf

clean:
	rm -f ~/.bashrc
	rm -f ~/.vimrc
	rm -f ~/.vim
	rm -f ~/.dir_colors
	rm -f ~/.gitconfig
	rm -f ~/.tmux.conf

