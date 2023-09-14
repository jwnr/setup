## インストール
wireguard-tools

## 設定ファイル設置
cp ./jkbrn.conf /etc/wireguard/

## ON / OFF
wg-quick up jkbrn
wg-quick down jkbrn
