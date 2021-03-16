#!/usr/bin/env bash

# Put .local/bin in PATH
echo "export PATH=\"$HOME/.local/bin:\$PATH\"" > .new_bash_aliases
if [ -f "~/.bash_aliases" ]; then
  grep -v "export PATH=" ~/.bash_aliases >> .new_bash_aliases
fi
mv .new_bash_aliases ~/.bash_aliases
source ~/.bash_aliases

sudo apt install ffmpeg build-essential cmake python3 python3-dev python3-pip libncurses-dev nodejs
npm python3-pip

pushd `dirname $0`

mkdir -p work
pushd work

if [ ! -d vim ]; then
  git clone https://github.com/vim/vim.git || exit 1
fi
pushd vim
make distclean || exit 1
./configure --with-features=huge --enable-multibyte --enable-pythoninterp=yes --enable-python3interp=yes --prefix=/usr/local/ || exit 1
make || exit 1
sudo make install
popd

sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
sudo update-alternatives --set editor /usr/local/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
sudo update-alternatives --set vi /usr/local/bin/vim

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  mkdir -p ~/.vim/bundle
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

cp ../../dotfiles/.vimrc ~/
/usr/local/bin/vim +PluginInstall +qall || exit 1

pushd ~/.vim/bundle/YouCompleteMe
python3 install.py --clangd-completer --ts-completer
popd

popd
popd

pip3 install bikeshed && bikeshed update
