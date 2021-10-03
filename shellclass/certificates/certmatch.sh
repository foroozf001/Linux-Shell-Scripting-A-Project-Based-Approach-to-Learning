#!/bin/bash 

# This script allows users to determine whether certificate files are matching or not by means of comparison of the public key checksums.

# Make sure the user supplies at least one argument. Display help otherwise.
if [[ "${#}" -lt 1 ]];then
  echo "This script allows users to determine whether certificate files are matching or not by means of comparison of the public key checksums."
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

# Loop over all positional parameters.
while [[ "${#}" -gt 0 ]];do
  case "${1}" in
    # Display help.
    -h|--help)    
      echo "This script allows users to determine whether certificate files are matching or not by means of comparison of the public key checksums."
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
    # Input parameter public key.
    -p|--public-key)
      shift
      PUBLIC_KEY_FILE="${1}"
      shift
      ;;
    # Input parameter certificate signing request.
    -c|--csr)
      shift
      CSR_FILE="${1}"
      shift
      ;;
    # Input parameter private key.
    -k|--private-key)
      shift
      PRIVATE_KEY_FILE="${1}"
      shift
      ;;
    # For invalid input parameters, display help.
    *)
      echo "Invalid argument: ${1}" 1>&2
      echo
      "${0}" -h
      break
      ;;
  esac
done

# Variable containing certificate checksums.
SUMS=()
if [[ -f "${PRIVATE_KEY_FILE}" ]];then  
  # User input passphrase.
  read -s -p "Enter pass phrase for ${PRIVATE_KEY_FILE}: " PASSPHRASE
  if [[ -z "${PASSPHRASE}" ]]; then
    echo 
    echo "empty passphrase" 1>&2
    exit 1
  fi
  echo  
  # Attempt to process private key, using passphrase.
  openssl pkey -in "${PRIVATE_KEY_FILE}" -passin pass:"${PASSPHRASE}" -pubout -outform pem &>/dev/null 
  if [[ "${?}" -eq 1 ]];then
    echo "invalid passphrase" 1>&2
    exit 1
  fi
  # Get private key checksum and append to array.
  PRIVATE_SUM=$(openssl pkey -in "${PRIVATE_KEY_FILE}" -passin pass:"${PASSPHRASE}" -pubout -outform pem | sha256sum)
  SUMS+=("${PRIVATE_SUM}")
fi

if [[ -f "${PUBLIC_KEY_FILE}" ]];then
  # Get public key checksum and append to array.
  PUBLIC_SUM=$(openssl x509 -in "${PUBLIC_KEY_FILE}" -pubkey -noout -outform pem | sha256sum)
  SUMS+=("${PUBLIC_SUM}")
fi 

if [[ -f "${CSR_FILE}" ]];then
  # Get csr checksum and append to array.
  CSR_SUM=$(openssl req -in "${CSR_FILE}" -pubkey -noout -outform pem | sha256sum)
  SUMS+=("${CSR_SUM}")
fi

LENGTH="${#SUMS[@]}"
for (( i=1; i<"${LENGTH}"; i++ ));do
  if [[ "${SUMS[0]}" != "${SUMS[$i]}" ]];then
    echo "no match" 
    exit 1
  fi
done
echo "match"
exit 0
