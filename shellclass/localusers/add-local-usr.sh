#!/bin/bash 
# Script creates new user accounts.  
ROOT_ID=0
ID=$(id -u)
if [[ "${ID}" -ne "${ROOT_ID}" ]]; then 
  echo "Your UID ${ID} does not match ${ROOT_ID}"
  exit 1
fi 
read -p "Please enter the new username: " USER_NAME 
if [[ -z "${USER_NAME}" ]]; then
  echo "Username is empty!" 
  exit 1
fi
read -p "Please enter the user's full name: " USER_COMMENT 
if [[ -z "${USER_COMMENT}" ]]; then
  echo "User's full name is empty!" 
  exit 1
fi
read -s -p "Please enter the new user's password: " USER_PASS 
if [[ -z "${USER_PASS}" ]]; then
  echo 
  echo "Password is empty!"
  exit 1
fi
echo
useradd -c "${USER_COMMENT}" -m "${USER_NAME}"
echo ${USER_PASS} | passwd --stdin ${USER_NAME}
passwd -e "${USER_NAME}"
echo "User ${USER_NAME}(${USER_COMMENT}) with password \"${USER_PASS}\" added to $(hostname)"
exit 0
