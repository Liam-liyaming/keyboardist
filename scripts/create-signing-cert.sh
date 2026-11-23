#!/bin/bash
# 创建本地自签名代码签名证书（只用于本机开发）
#
# 作用：让每次重新编译都保持同一个签名身份，TCC（辅助功能/输入监控）
#       的授权记录就不会因为 CDHash 变化而失效。
#
#   ./scripts/create-signing-cert.sh            # 默认名字 "Keyboardist Dev"
#   ./scripts/create-signing-cert.sh "My Name"
#
# 之后构建时：
#   ./scripts/build-app.sh                      # 会自动检测并使用该证书
set -euo pipefail

NAME="${1:-Keyboardist Dev}"
KEYCHAIN="$HOME/Library/Keychains/login.keychain-db"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

if security find-identity -v -p codesigning 2>/dev/null | grep -q "$NAME"; then
    echo "✅ 已存在签名身份：$NAME"
    security find-identity -v -p codesigning | grep "$NAME"
    exit 0
fi

echo "→ 生成自签名证书：$NAME"
openssl req -x509 -newkey rsa:2048 -sha256 -days 3650 -nodes \
    -keyout "$WORK/key.pem" -out "$WORK/cert.pem" \
    -subj "/CN=$NAME/O=Keyboardist/C=CN" \
    -addext "basicConstraints=critical,CA:false" \
    -addext "keyUsage=critical,digitalSignature" \
    -addext "extendedKeyUsage=critical,codeSigning" >/dev/null 2>&1

openssl pkcs12 -export -inkey "$WORK/key.pem" -in "$WORK/cert.pem" \
    -out "$WORK/id.p12" -passout pass:keyboardist -name "$NAME" >/dev/null 2>&1

echo "→ 导入登录钥匙串"
security import "$WORK/id.p12" -k "$KEYCHAIN" -P keyboardist \
    -T /usr/bin/codesign -T /usr/bin/security >/dev/null

echo "→ 信任该证书用于代码签名（可能弹一次系统授权框）"
security add-trusted-cert -r trustRoot -p codeSign -k "$KEYCHAIN" "$WORK/cert.pem" 2>/dev/null || \
    echo "  ⚠️  自动信任失败，请在「钥匙串访问」里手动把该证书设为「始终信任」"

echo "→ 校验"
security find-identity -v -p codesigning | grep "$NAME" || {
    echo "❌ 没找到可用身份，请打开「钥匙串访问」检查证书是否被信任"
    exit 1
}
echo "✅ 完成。以后 ./scripts/build-app.sh 会自动用它签名。"
