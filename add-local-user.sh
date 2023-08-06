#!/bin/bash

# Check if user is root user

if [[ "${UID}" -ne 0 ]]
then
  echo "Your UID is ${UID}. You are not root user"
  exit 1
fi

# create account username

read -p 'Create a username: ' USER_NAME

# create account full name (comment)

read -p "Enter ${USER_NAME}'s full name: " COMMENT

# create account password

read -p "Enter ${USER_NAME}'s password: " PASSWORD

# add user 

useradd -c "${COMMENT}" -m ${USER_NAME}

# check if user creation is successful

if [[ "${?}" -ne 0 ]]
then
  echo "The account creation was unsuccessful"
  exit 1
fi

echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# check if user password creation is successful

if [[ "${?}" -ne 0 ]]
then
  echo "The account password was unsuccessful"
  exit 1
fi

# set password

passwd -e ${USER_NAME}

# display username, password, host

echo
echo 'username:'
echo "${USER_NAME}"
echo
echo 'password:'
echo "${PASSWORD}"
echo
echo 'host:'
echo "${HOSTNAME}"
echo 
exit 0