#
# git-completion.bash / git-prompt.sh  @sshrc
#
if [ -f $SSHHOME/.sshrc.d/.git-completion.bash ] || [ -f $HOME/.git-completion.bash ]; then
    source $HOME/.git-completion.bash
    # __git_ps1のエラー用1
    source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
fi
if [ -f $SSHHOME/.sshrc.d/.git-prompt.sh ] || [ -f $HOME/.git-prompt.sh ]; then
    source $HOME/.git-prompt.sh
    # __git_ps1のエラー用1
    source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh
fi

# プロンプトに各種情報を表示
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUPSTREAM=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWSTASHSTATE=true

############### ターミナルのコマンド受付状態の表示変更
# \u ユーザ名
# \h ホスト名
# \W カレントディレクトリ
# \w カレントディレクトリのパス
# \n 改行
# \d 日付
# \[ 表示させない文字列の開始
# \] 表示させない文字列の終了
# \$ $
# export PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\n\$ '

if [ -f $SSHHOME/.sshrc.d/.git-prompt.sh ] || [ -f $HOME/.git-prompt.sh ]; then
    export PS1='\[\e[1;34m\]\t \[\033[32m\]\u:\[\033[33m\]\w\n\[\e[1;32m\]\[\033[36m\]$(__git_ps1)\[\033[00m\] $ '
else
    export PS1='\[\e[1;34m\]\t \[\033[32m\]\u:\[\033[33m\]\w\n\[\e[1;32m\]\[\033[36m\]\[\033[00m\] $ '
fi
##############

git_branch() {
  echo $(git branch --no-color 2>/dev/null | sed -ne "s/^\* \(.*\)$/\1/p")
}

function git_diff_archive()
{
  local diff=""
  local h="HEAD"
  if [ $# -eq 1 ]; then
    if expr "$1" : '[0-9]*$' > /dev/null ; then
      diff="HEAD~${1} HEAD"
    else
      diff="${1} HEAD"
    fi
  elif [ $# -eq 2 ]; then
    diff="${2} ${1}"
    h=$1
  fi
  if [ "$diff" != "" ]; then
    diff="git diff --diff-filter=d --name-only ${diff}"
  fi
  git archive --format=zip --prefix=root/ $h `eval $diff` -o archive.zip
}

# bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

############# alias
#### Git
alias g='git'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gp='git push'
# 空白等の差分は無視して表示
alias gd='git diff -b'

### phpのローカルサーバーを立ち上げる
alias phpS='php -S localhost:9000'

alias ll='ls -la'
alias cdw='cd ~/Documents/work/'

### ショートカット
alias gitconfig='vim ~/.gitconfig'
alias ssh_hosts='sh ~/.ssh/known_ssh_hosts.sh'

### 検索ワンライナー
alias goo='searchByGoogle'
function searchByGoogle() {
    # 第一引数がない場合はpbpasteの中身を検索単語とする
    [ -z "$1" ] && searchWord=`pbpaste` || searchWord=$1
    open https://www.google.co.jp/search\?q\=$searchWord
}

### Application
alias typora="open -a typora"

### ghkw
GITHUB_TOKEN=10e1eed8a62e8499cc8beee754da96dd560627b8
export GITHUB_TOKEN

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
