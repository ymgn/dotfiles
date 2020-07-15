# ymgnのdotfiles
.で始まるファイルやディレクトリを管理するRepository

dotfilesのファイルを変更した場合はcommitし、新規で追加する場合は合わせて ```dotfilesdotfilesLink.sh```にシンボリックリンクのコマンドを追加する

## 使い方
gitの状態を表示させるためのプラグインをbrewで追加
``` brew install zsh-git-prompt ```

``` sh ~/dotfiles/dotfilesLink.sh ```

### 問題があった場合
https://qiita.com/ayihis@github/items/88f627b2566d6341a741
立ち上げるときになにか警告が出る場合
```
zsh compinit: insecure directories, run compaudit for list.
Ignore insecure directories and continue [y] or abort compinit [n]?
```

```
compaudit
```
で原因を調べ、以下の２つが原因だった場合は権限を適切なものに治す
```
chmod 755 /usr/local/share/zsh
chmod 755 site-functions/     
```

##  参考にしたサイト
- https://qiita.com/yutakatay/items/c6c7584d9795799ee164
- https://issueoverflow.com/2017/03/14/how-to-display-the-repository-status-with-zsh-git-prompt/
- https://qiita.com/ryuichi1208/items/2eef96debebb15f5b402
