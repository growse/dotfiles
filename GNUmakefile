.PHONY: clean install


install: ~/.bashrc ~/.vimrc ~/.vim ~/.dir_colors ~/.gitconfig

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

clean:
	rm -f ~/.bashrc
	rm -f ~/.vimrc
	rm -f ~/.vim
	rm -f ~/dir_colors
	rm -f ~/.gitconfig

