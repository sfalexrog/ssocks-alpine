#!/bin/sh

echo "Password: $PASSWORD"
echo "Encrypt: $ENCRYPT"
echo "V2_Path: $V2_Path"
DOMAIN="${AppName}.heroku.com"
echo "Domain: $DOMAIN"
echo "QR info location: $QR_Path"

mkdir -p /etc/shadowsocks

jq ".password = \"${PASSWORD}\" | .method = \"${ENCRYPT}\" | .plugin_opts = \"server;path=/${V2_Path}\"" ./conf/shadowsocks.json > /etc/shadowsocks/shadowsocks.json

mkdir -p "/wwwroot/$QR_Path"

plugin="$(echo "v2ray;path=/${V2_Path};host=${DOMAIN};tls" | sed -e 's/\//%2F/g' -e 's/=/%3D/g' -e 's/;/%3B/g')"
ss="ss://$(echo "$ENCRYPT":"$PASSWORD" | base64 -w 0)@${DOMAIN}:443?plugin=${plugin}"
echo "${ss}" | tr -d '\n' > "/wwwroot/${QR_Path}/index.html"
echo "${ss}" | qrencode -s 6 -o "/wwwroot/${QR_Path}/vpn.png"

echo "admin:$(cryptpw "${PASSWORD}")" > "/wwwroot/${QR_Path}/.htpasswd"
sed -e "s/PORT/${PORT}/g" -e "s/QR_INFO/${QR_Path}/g" -e "s/V2RAY_LOCATION/${V2_Path}/g" ./conf/nginx.conf > /etc/nginx/http.d/ss.conf
