#!/bin/bash

# STDIN is File Descriptor 0
# STDOUT is File Descriptor 1
# STDERR is File Descriptor 2

# This script demonstrates I/O redirection.

# Redirect STDOUT to file
FILE="/vagrant/data"
head -n1 /etc/passwd > "${FILE}"

# Redirect STDIN to a command.
echo
read LINE < "${FILE}"
echo "Line contains: ${LINE}"

# Redirect STDOUT to a file, overwriting the file.
echo
head -n3 /etc/passwd > "${FILE}"
echo "Contents of ${FILE}"
cat "${FILE}"

# Redirect STDOUT to a file, appending to the file.
echo
echo "${RANDOM} ${RANDOM}" >> "${FILE}"
echo "${RANDOM} ${RANDOM}" >> "${FILE}"
echo "Contents of ${FILE}"
cat "${FILE}"

# Redirect STDIN to a program, using File Descriptor (FD) 0.
echo
read LINE 0< "${FILE}"
echo "Line contains: ${LINE}"

# Redirect STDOUT to a file, using FD 1, overwriting the file.
echo
head -n3 /etc/passwd 1> "${FILE}"
echo "Contents of file ${FILE}:"
cat "${FILE}"

# Redirect STDERR to a file, using FD 2.
echo
ERR_FILE="/vagrant/data.err"
head -n3 /etc/passwd /fakefile 2> "${ERR_FILE}"
echo "Contents of ${ERR_FILE}:"
cat "${ERR_FILE}"

# Redirect STDOUT & STDERR to a file.
echo
head -n3 /etc/passwd /fakefile &> "${ERR_FILE}"
echo "Contents of ${ERR_FILE}:"
cat "${ERR_FILE}"

# Redirect STDOUT & STDERR through a pipe.
echo
head -n3 /etc/passwd /fakefile |& cat -n

# Send STDOUT to STDERR
echo
echo "This is STDERR!" 1>&2

# Discard STDOUT, using the null-device
echo
echo "Discarding STDOUT:"
head -n3 /etc/passwd /fakefile 1> /dev/null
echo "${?}"

# Discard STDERR, using the null-device
echo
echo "Discarding STDERR:"
head -n3 /etc/passwd /fakefile 2> /dev/null
echo "${?}"

# Discard both STDOUT & STDERR, using the null-device
echo
echo "Discarding both STDOUT & STDERR:"
head -n3 /etc/passwd /fakefile &> /dev/null
echo "${?}"

# Cleanup
rm "${FILE}" "${ERR_FILE}" &> /dev/null
