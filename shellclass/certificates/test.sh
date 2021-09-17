#!/bin/bash 
while getopts p:k:c: flag
do
    case "${flag}" in
        p) INPUT_PUBLIC_CERTIFICATE=${OPTARG};;
	k) INPUT_PRIVATE_KEY=${OPTARG};;
        c) INPUT_CSR=${OPTARG};;
    esac
done

PUBLIC_KEY_SUM=$((openssl x509 -in $INPUT_PUBLIC_CERTIFICATE -pubkey -noout -outform pem 2> /dev/null 2> /dev/null) | sha256sum)
PRIVATE_KEY_SUM=$((openssl pkey -in $INPUT_PRIVATE_KEY -pubout -outform pem 2> /dev/null) | sha256sum)
echo $PUBLIC_KEY_SUM
echo $PRIVATE_KEY_SUM
if [[ "${PRIVATE_KEY_SUM}" = "${PUBLIC_KEY_SUM}" ]];
then
  echo "Match!"
else
  echo "Mismatch!"
  exit 1
fi
exit 0
