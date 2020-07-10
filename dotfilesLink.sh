#!/bin/sh
## mac
# bash
ln -sf ~/dotfiles/mac/bash/.bash_profile ~/.bash_profile
ln -sf ~/dotfiles/mac/bash/.bashrc ~/.bashrc

# git
ln -sf ~/dotfiles/mac/git/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/mac/git/.git-completion.bash ~/.git-completion.bash
ln -sf ~/dotfiles/mac/git/.git-completion.zsh ~/.git-completion.zsh
ln -sf ~/dotfiles/mac/git/.git-prompt.sh ~/.git-prompt.sh
ln -sf ~/dotfiles/mac/git/.gitignore_global ~/.gitignore_global

# vim
ln -sf ~/dotfiles/mac/vim/.vimrc ~/.vimrc

# tig
ln -sf ~/dotfiles/mac/tig/.tigrc ~/.tigrc

# zsh
ln -sf ~/dotfiles/mac/zsh/.zshrc ~/.zshrc

# bashでの小文字大文字区別しない設定
ln -sf ~/dotfiles/mac/.inputrc ~/.inputrc

## ssh
# sshの接続のエイリアス設定等
ln -sf ~/dotfiles/ssh/.ssh/config ~/.ssh/config
ln -sf ~/dotfiles/ssh/.ssh/known_ssh_hosts.sh ~/.ssh/known_ssh_hosts.sh

# sshrc
ln -sf ~/dotfiles/.sshrc ~/.sshrc

# .sshrc.d ディレクトリがなければ作って.sshrcに必要なファイルのシンボリックリンクを作成
mkdir -p ~/.sshrc.d 2>/dev/null
ln -sf ~/dotfiles/.bashrc ~/.sshrc.d/.bashrc
ln -sf ~/dotfiles/.vimrc ~/.sshrc.d/.vimrc
