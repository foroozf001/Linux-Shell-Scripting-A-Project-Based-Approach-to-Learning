#!/bin/bash

# This script demonstrates I/O redirection.

# Redirect STDOUT to file
FILE="/vagrant/data"
head -n1 /etc/passwd > "${FILE}"

# Redirect STDIN to a command.
read LINE < "${FILE}"
echo "Line contains: ${LINE}"

# Redirect STDOUT to a file, overwriting the file.
head -n3 /etc/passwd > "${FILE}"
echo
echo "Contents of ${FILE}"
cat "${FILE}"

# Redirect STDOUT to a file, appending to the file.
echo "${RANDOM} ${RANDOM}" >> "${FILE}"
echo "${RANDOM} ${RANDOM}" >> "${FILE}"

echo
echo "Contents of ${FILE}"
cat "${FILE}"
