#!/bin/sh

say() {
  printf '%s\n' "$*"
}

ok_list=""
fail_list=""
skip_list=""
last_cmd=""
last_failed_cmd=""

count_lines() {
  if [ -z "$1" ]; then
    printf '%s' "0"
    return
  fi
  printf "%b" "$1" | sed '/^$/d' | wc -l | tr -d ' '
}

print_list() {
  title=$1
  list=$2
  count=$(count_lines "$list")
  say "${title} (${count}):"
  if [ "${count}" -eq 0 ]; then
    say "- なし"
  else
    printf "%b" "${list}" | sed '/^$/d; s/^/- /'
  fi
}

record_ok() {
  ok_list="${ok_list}${1}\n"
}

record_fail() {
  fail_list="${fail_list}${1}\n"
}

record_skip() {
  skip_list="${skip_list}${1}\n"
}

run_step() {
  label=$1
  shift
  say "==> 実行: ${label}"
  last_cmd="$*"
  if "$@"; then
    say "成功: ${label}"
    record_ok "${label}"
  else
    say "失敗: ${label}"
    last_failed_cmd="$*"
    record_fail "${label}"
  fi
}

skip_step() {
  label=$1
  reason=$2
  if [ -n "${reason}" ]; then
    say "==> スキップ: ${label}（${reason}）"
  else
    say "==> スキップ: ${label}"
  fi
  record_skip "${label}"
}

install_homebrew() {
  tmp_file=$(mktemp)
  if [ -z "${tmp_file}" ]; then
    return 1
  fi
  if ! curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh > "${tmp_file}"; then
    rm -f "${tmp_file}"
    return 1
  fi
  /bin/bash "${tmp_file}"
  rc=$?
  rm -f "${tmp_file}"
  return "${rc}"
}

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
if [ -z "${SCRIPT_DIR}" ]; then
  say "スクリプトのディレクトリを特定できません。"
  exit 1
fi
cd "${SCRIPT_DIR}" || exit 1

if [ "$(uname)" != "Darwin" ]; then
  say "このセットアップは macOS 専用です。"
  exit 1
fi

if [ ! -d /opt/homebrew ]; then
  say "Apple Silicon の Homebrew パス (/opt/homebrew) が見つかりません。"
  say "このセットアップは Apple Silicon macOS 専用です。"
  exit 1
fi

if xcode-select -p >/dev/null 2>&1; then
  skip_step "Xcode Command Line Tools" "既にインストール済み"
else
  run_step "Xcode Command Line Tools のインストール" xcode-select --install
fi

if command -v brew >/dev/null 2>&1; then
  skip_step "Homebrew のインストール" "既にインストール済み"
else
  run_step "Homebrew のインストール" install_homebrew
fi

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v brew >/dev/null 2>&1; then
  skip_step "Brew bundle" "brew が見つからない"
elif [ ! -f Brewfile ]; then
  skip_step "Brew bundle" "Brewfile が見つからない"
else
  run_step "Brew bundle" brew bundle --file Brewfile
fi

if [ -f ./dotfilesLink.sh ]; then
  run_step "dotfiles のシンボリックリンク作成" sh ./dotfilesLink.sh
else
  record_fail "dotfiles のシンボリックリンク作成"
  say "dotfilesLink.sh が見つかりません。"
fi

if [ "${SHELL:-}" != "/bin/zsh" ]; then
  run_step "ログインシェルを zsh に変更" chsh -s /bin/zsh
else
  skip_step "ログインシェルを zsh に変更" "既に zsh"
fi

say ""
say "==== 結果まとめ ===="
print_list "成功" "${ok_list}"
print_list "スキップ" "${skip_list}"
print_list "失敗" "${fail_list}"
if [ -n "${last_failed_cmd}" ]; then
  say "最後に失敗したコマンド: ${last_failed_cmd}"
fi
if [ -n "${fail_list}" ]; then
  exit 1
fi

exit 0
