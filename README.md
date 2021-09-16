
```
## セットアップ [root実行]
curl -sL s.wnr.jp/alm | sh
curl -sL s.wnr.jp/mjr | sh
※sudoではなく

## ドットファイルデプロイ [ユーザー実行]
cd ~
curl -OL -u user k.wnr.jp/ssh.tgz
tar xf ssh.tgz
chmod 400 .ssh/id_rsa
rm -f .ssh/id_rsa.pub
curl -sL d.wnr.jp | sh
```
