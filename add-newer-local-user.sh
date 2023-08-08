#!/bin/bash

# Make sure the script is being executed with superuser privileges.
if [[ "$UID" -ne 0  ]]
then
  echo "Your UID is ${UID}. You are not super user." >&2
  exit 1
fi



# If the user doesn't supply at least one argument, then give them help.
if [[ "${#}" -lt 1  ]]
then
  # echo
  echo "Number of arguments supplied: ${#}." >&2
  echo "Please enter at least one argument: ./$(basename ${0}) [ARGUMENT]" >&2
  exit 1
fi

# The first parameter is the user name.
USER_NAME="${1}"

# The rest of the parameters are for the account comments.
COMMENT="${@}"

# Generate a password.
PASSWORD=$(date +%s%N)

# Create the user with the password.
useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null

# check if user creation is successful
if [[ "${?}" -ne 0 ]]
then
  echo "The account creation was unsuccessful" >&2
  exit 1
fi

# Create the user with the password
echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null

# check if user password creation is successful
if [[ "${?}" -ne 0 ]]
then
  echo "The account password was unsuccessful" >&2
  exit 1
fi

# Force password change on first login.
passwd -e ${USER_NAME} &> /dev/null

# Display the username, password, and the host where the user was created.
echo 'username:'
echo "${USER_NAME}"
echo
echo 'password:'
echo
echo 'host:'
echo "${HOSTNAME}"
exit 0