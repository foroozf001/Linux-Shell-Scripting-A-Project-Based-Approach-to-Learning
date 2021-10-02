#!/bin/bash 

#while getopts p:k:c: flag
#do
#    case "${flag}" in
#        p) INPUT_PUBLIC_CERTIFICATE=${OPTARG};;
#	k) INPUT_PRIVATE_KEY=${OPTARG};;
#        c) INPUT_CSR=${OPTARG};;
#    esac
#done

read -s -p "Enter pass phrase for server.key: " PASSPHRASE
if [[ -z "${PASSPHRASE}" ]]; then
  echo 
  echo "empty passphrase" 1>&2
  exit 1
fi

echo

RESULT=$(openssl pkey -in server.key -passin pass:"${PASSPHRASE}" -pubout -outform pem 2>&1)

#if [[ ! -z $(openssl pkey -in server.key -passin pass:"${PASSPHRASE}" -pubout -outform pem 2>&1) ]];then
#  echo "unable to load key" 1>&2
#  exit 1
#fi

#PRIVATE_SUM=$(openssl pkey -in server.key -passin pass:"${PASSPHRASE}" -pubout -outform pem |& sha256sum)
#PUBLIC_SUM=$(openssl x509 -in server.crt -pubkey -noout -outform pem |& sha256sum)
#echo "${PRIVATE_SUM}"
#echo "${?}"
#
##echo $PUBLIC_KEY_SUM
#echo $PRIVATE_KEY_SUM
#
#if [[ "${PRIVATE_KEY_SUM}" = "${PUBLIC_KEY_SUM}" ]];
#then
#  echo "Match!"
#else
#  echo "Mismatch!"
#  exit 1
#fi
#exit 0
