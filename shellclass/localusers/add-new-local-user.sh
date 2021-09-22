#!/bin/bash
# Script creates new user accounts.  
ROOT_ID=0
ID=$(id -u)
if [[ "${ID}" -ne "${ROOT_ID}" ]]; then 
  echo "Your UID ${ID} does not match ${ROOT_ID}"
  exit 1
fi
# Make sure they at least supply one argument.
if [[ "${#}" -lt 1 ]];then
  echo "Usage: ${0} USER_NAME [COMMENT]..."
  exit 1
fi 
USER_NAME="${1}"
shift
COMMENT="${*}"
PASSWORD=$(date +s%N | sha256sum | head -c48)
useradd -c "${COMMENT}" -m "${USER_NAME}"
if [[ "${?}" -ne 0 ]];then
  echo "The account could not be created."
  exit 1
fi
echo "${PASSWORD}" | passwd --stdin "${USER_NAME}"
if [[ "${?}" -ne 0 ]];then
  echo "The password for the account could not be set."
  exit 1
fi
passwd -e "${USER_NAME}"
echo "Username:"
echo "${USER_NAME}"
echo "Password:"
echo "${PASSWORD}"
echo "Host:"
echo "${HOSTNAME}"
exit 0
