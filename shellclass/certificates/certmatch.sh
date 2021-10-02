#!/bin/bash 

# This script determines certificate files are a match.

if [[ "${#}" -lt 1 ]];then
  echo "Determine certificates are matching or not."
  echo
  echo "Usage:"
  echo "  ${0} [OPTIONS]..."
  echo
  echo "Options:"
  echo "  -h, --help"
  echo "  -p, --public-key	public key"
  echo "  -c, --csr		certificate signing request"
  echo "  -k, --private-key	private key"
  echo
  exit 1
fi

while [[ "${#}" -gt 0 ]];do
  case "${1}" in
    -h|--help)    
      echo "Determine certificates are matching or not."
      echo
      echo "Usage:"
      echo "  ${0} [OPTIONS]..."
      echo
      echo "Options:"
      echo "  -h, --help"
      echo "  -p, --public-key	public key"
      echo "  -c, --csr		certificate signing request"
      echo "  -k, --private-key	private key"
      echo
      exit 0
      ;;
    -p|--public-key)
      shift
      PUBLIC_KEY_FILE="${1}"
      shift
      ;;
    -c|--csr)
      shift
      CSR_FILE="${1}"
      shift
      ;;
    -k|--private-key)
      shift
      PRIVATE_KEY_FILE="${1}"
      shift
      ;;
    *)
      echo "Invalid argument: ${1}" 1>&2
      echo
      "${0}" -h
      break
      ;;
  esac
done

if [[ -f "${PRIVATE_KEY_FILE}" ]];then  
  read -s -p "Enter pass phrase for ${PRIVATE_KEY_FILE}: " PASSPHRASE
  if [[ -z "${PASSPHRASE}" ]]; then
    echo 
    echo "empty passphrase" 1>&2
    exit 1
  fi
  echo  
  openssl pkey -in "${PRIVATE_KEY_FILE}" -passin pass:"${PASSPHRASE}" -pubout -outform pem &>/dev/null 
  if [[ "${?}" -eq 1 ]];then
    echo "invalid passphrase" 1>&2
    exit 1
  fi
  PRIVATE_SUM=$(openssl pkey -in "${PRIVATE_KEY_FILE}" -passin pass:"${PASSPHRASE}" -pubout -outform pem |& sha256sum)
fi

if [[ -f "${PUBLIC_KEY_FILE}" ]];then
  PUBLIC_SUM=$(openssl x509 -in "${PUBLIC_KEY_FILE}" -pubkey -noout -outform pem |& sha256sum)
fi 

if [[ -f "${CSR_FILE}" ]];then
  CSR_SUM=$(openssl req -in "${CSR_FILE}" -pubkey -noout -outform pem |& sha256sum)
fi 

for i in "${PRIVATE_SUM}" "${PUBLIC_SUM}" "${CSR_SUM}";do
  if [[ -n "${i}" ]];then
  fi
done
