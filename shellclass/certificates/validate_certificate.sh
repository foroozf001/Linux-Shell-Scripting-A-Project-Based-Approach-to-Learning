#!/bin/bash
read -s -p "Please enter key passphrase: " PASSPHRASE
if [[ -z "${PASSPHRASE}" ]]; then
  echo 
  echo "Password is empty!"
  exit 1
fi
echo
KEY_SHA256=$(openssl pkey -in server.key -passin pass:$PASSPHRASE -pubout -outform pem | sha256sum)
PUB_SHA256=$(openssl x509 -in server.crt -pubkey -noout -outform pem | sha256sum)
if [[ "${KEY_SHA256}" = "${PUB_SHA256}" ]];
then
  echo "Match!"
else
  echo "Mismatch!"
  exit 1
fi

exit 0
