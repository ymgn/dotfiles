# -----------------------------
# Lang
# -----------------------------
#export LANG=ja_JP.UTF-8
#export LESSCHARSET=utf-8

# -----------------------------
# General
# -----------------------------
# 色を使用
autoload -Uz colors ; colors

# エディタをvimに設定
export EDITOR=vim

# Ctrl+Dでログアウトしてしまうことを防ぐ
#setopt IGNOREEOF

# Homebrew (Apple Silicon) と個人bin
if [ -d /opt/homebrew/bin ]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi
export PATH="$HOME/bin:$PATH"

# Load NVM lazily for faster shell startup
export NVM_DIR="$HOME/.nvm"
nvm_lazy_load() {
  unset -f node npm npx nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}
for _nvm_cmd in node npm npx nvm; do
  eval "${_nvm_cmd}() { nvm_lazy_load; ${_nvm_cmd} \"\$@\"; }"
done
unset _nvm_cmd

# cdした際のディレクトリをディレクトリスタックへ自動追加
setopt auto_pushd

# ディレクトリスタックへの追加の際に重複させない
setopt pushd_ignore_dups

# emacsキーバインド
#bindkey -e

# viキーバインド
bindkey -v

# フローコントロールを無効にする
setopt no_flow_control

# ワイルドカード展開を使用する
setopt extended_glob

# コマンドラインがどのように展開され実行されたかを表示するようになる
#setopt xtrace

# ビープ音を鳴らさないようにする
#setopt no_beep

# カッコの対応などを自動的に補完する
setopt auto_param_keys

# ディレクトリ名の入力のみで移動する
setopt auto_cd

# bgプロセスの状態変化を即時に知らせる
setopt notify

# 終了ステータスが0以外の場合にステータスを表示する
setopt print_exit_value

# ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt mark_dirs

# コマンドのスペルチェックをする
setopt correct

# コマンドライン全てのスペルチェックをする
setopt correct_all

# 上書きリダイレクトの禁止
setopt no_clobber

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# パスの最後のスラッシュを削除しない
setopt noautoremoveslash

# 各コマンドが実行されるときにパスをハッシュに入れる
#setopt hash_cmds

# rsysncでsshを使用する
export RSYNC_RSH=ssh

# その他
umask 022
ulimit -c 0

# -----------------------------
# Prompt
# -----------------------------
# %M    ホスト名
# %m    ホスト名
# %d    カレントディレクトリ(フルパス)
# %~    カレントディレクトリ(フルパス2)
# %C    カレントディレクトリ(相対パス)
# %c    カレントディレクトリ(相対パス)
# %n    ユーザ名
# %#    ユーザ種別
# %?    直前のコマンドの戻り値
# %D    日付(yy-mm-dd)
# %W    日付(yy/mm/dd)
# %w    日付(day dd)
# %*    時間(hh:flag_mm:ss)
# %T    時間(hh:mm)
# %t    時間(hh:mm(am/pm))

# PROMPT変数内で変数参照する
setopt prompt_subst

if [ -r "/opt/homebrew/opt/zsh-git-prompt/zshrc.sh" ]; then
  source "/opt/homebrew/opt/zsh-git-prompt/zshrc.sh"
  ZSH_THEME_GIT_PROMPT_PREFIX="["
  ZSH_THEME_GIT_PROMPT_SUFFIX=" ]"
  ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[white]%}"
  ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}%{ %G%}"
  ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[magenta]%}%{x%G%}"
  ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[red]%}%{+%G%}"
  ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[red]%}%{-%G%}"
  ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[green]%}%{+%G%}"
  ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}%{✔%G%}"
  PROMPT='%{${fg[green]}%}%n%{${reset_color}%}@%F{blue}localhost%f:~%F{green}%d%f$(git_super_status) $ '
else
  PROMPT='%{${fg[green]}%}%n%{${reset_color}%}@%F{blue}localhost%f:~%F{green}%d%f $ '
fi
RPROMPT='[%W %T]'
# -----------------------------
# Completion
# -----------------------------
# 自動補完を有効にする
autoload -Uz compinit && compinit -C

# 単語の入力途中でもTab補完を有効化
#setopt complete_in_word

# 補完の選択を楽にする
zstyle ':completion:*' menu select

# 補完候補をできるだけ詰めて表示する
setopt list_packed

# 補完候補にファイルの種類も表示する
#setopt list_types

# 色の設定
export LSCOLORS=Exfxcxdxbxegedabagacad

# 補完時の色設定
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# キャッシュの利用による補完の高速化
zstyle ':completion::complete:*' use-cache true

# 補完候補に色つける
autoload -U colors ; colors ; zstyle ':completion:*' list-colors "${LS_COLORS}"
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 大文字・小文字を区別しない(大文字を入力した場合は区別する)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# manの補完をセクション番号別に表示させる
zstyle ':completion:*:manuals' separate-sections true

# --prefix=/usr などの = 以降でも補完
setopt magic_equal_subst

# -----------------------------
# History
# -----------------------------
# 基本設定
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000

# ヒストリーに重複を表示しない
setopt histignorealldups

# 他のターミナルとヒストリーを共有
setopt share_history

# 直前のコマンドの重複を削除
setopt hist_ignore_dups

# すでにhistoryにあるコマンドは残さない
setopt hist_ignore_all_dups

# historyに日付を表示
alias h="fc -lt '%F %T' 1"

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 履歴をすぐに追加する
setopt inc_append_history

# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_verify

#余分なスペースを削除してヒストリに記録する
#setopt hist_reduce_blanks

# historyコマンドは残さない
#setopt hist_save_no_dups

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
#bindkey '^R' history-incremental-pattern-search-backward
#bindkey "^S" history-incremental-search-forward

# ^P,^Nを検索へ割り当て
#bindkey "^P" history-beginning-search-backward-end
#bindkey "^N" history-beginning-search-forward-end

# -----------------------------
# Alias
# -----------------------------
# グローバルエイリアス
alias -g L='| less'
alias -g H='| head'
alias -g G='| grep'
alias -g GI='| grep -ri'

# エイリアス
alias lst='ls -ltr -G'
alias ls='ls -G'
alias la='ls -la -G'
alias ll='ls -l -G'

if command -v gdu >/dev/null 2>&1; then
  alias du="gdu -h"
else
  alias du="du -h"
fi
if command -v gdf >/dev/null 2>&1; then
  alias df="gdf -h"
else
  alias df="df -h"
fi
alias su="su -l"
alias so='source'
alias vi='vim'
alias vz='vim ~/.zshrc'
alias c='cdr'
alias cp='cp -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias ..='c ../'
alias back='pushd'
alias diff='diff -U1'

alias tma='tmux attach'
alias tml='tmux list-window'

alias dki="docker run -i -t -P"
alias dex="docker exec -i -t"
alias drmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

docker_compose() {
  if command -v docker-compose >/dev/null 2>&1; then
    command docker-compose "$@"
  else
    command docker compose "$@"
  fi
}

alias logall="docker_compose logs -f --tail=100"
alias logweb="docker_compose logs -f --tail=500 cw-web-php-fpm"
alias sshweb="docker_compose exec cw-web-php-fpm /bin/bash"

# -----------------------------
# Plugin
# -----------------------------
# root のコマンドはヒストリに追加しない
#if [ $UID = 0 ]; then
#  unset HISTFILE
#  SAVEHIST=0
#fi

#function h {
#  history
#}

#function g() {
#  egrep -r "$1" .
#}

function t()
{
  tmux new-session -s $(pwd |sed -E 's!^.+/([^/]+/[^/]+)$!\1!g' | sed -e 's/\./-/g')
}

function psgrep() {
  ps aux | grep -v grep | grep "USER.*COMMAND"
  ps aux | grep -v grep | grep $1
}

function dstop()
{
  docker stop $(docker ps -a -q);
}

function drm()
{
  docker rm $(docker ps -a -q);
}

# -----------------------------
# Plugin
# -----------------------------
ANTIDOTE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/antidote"
ANTIDOTE_HOME=""
ANTIDOTE_BUNDLE="${ANTIDOTE_DIR}/antidote.zshrc"
ANTIDOTE_PLUGINS="$HOME/dotfiles/mac/zsh/antidote.plugins.txt"

if [[ -r "/opt/homebrew/opt/antidote/share/antidote/antidote.zsh" ]]; then
  ANTIDOTE_HOME="/opt/homebrew/opt/antidote/share/antidote"
elif [[ -r "$HOME/.antidote/antidote.zsh" ]]; then
  ANTIDOTE_HOME="$HOME/.antidote"
elif [[ -r "${ANTIDOTE_DIR}/antidote/antidote.zsh" ]]; then
  ANTIDOTE_HOME="${ANTIDOTE_DIR}/antidote"
fi

if [[ -n "${ANTIDOTE_HOME}" ]]; then
  source "${ANTIDOTE_HOME}/antidote.zsh"
  if [[ -r "${ANTIDOTE_PLUGINS}" ]]; then
    if [[ ! -f "${ANTIDOTE_BUNDLE}" || "${ANTIDOTE_PLUGINS}" -nt "${ANTIDOTE_BUNDLE}" ]]; then
      mkdir -p "${ANTIDOTE_DIR}"
      antidote bundle < "${ANTIDOTE_PLUGINS}" >| "${ANTIDOTE_BUNDLE}"
    fi
    source "${ANTIDOTE_BUNDLE}"
  fi
fi

# ChatworkTools
export PATH=~/Source/chatwork_tools/bin:$PATH

# -----------------------------
# Python
# -----------------------------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"
alias pipallupgrade="pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U"

# -----------------------------
# Golang
# -----------------------------
if which go > /dev/null 2>&1  ; then
  export CGO_ENABLED=1
  export GOPATH=$HOME/dev/go
  export PATH=$PATH:$(go env GOROOT)/bin:$GOPATH/bin
fi


# -----------------------------
# JDK
# -----------------------------
#export JAVA_HOME=$(/usr/libexec/java_home)

# -----------------------------
# Git
# -----------------------------
function gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -200'
}

function gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}

function gs() {
  is_in_git_repo || return
  git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' |
  cut -d: -f1
}

# JDK

# Added by Antigravity
export PATH="/Users/ymgn/.antigravity/antigravity/bin:$PATH"

# -----------------------------
# Powerlevel10k
# -----------------------------
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH="$HOME/flutter/bin:$PATH"
export PATH="$PATH":"$HOME/.pub-cache/bin"
