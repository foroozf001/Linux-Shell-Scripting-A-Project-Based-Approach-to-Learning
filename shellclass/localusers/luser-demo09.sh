#!/bin/bash

# This script demonstrates the case statement.
case "${1}" in
	start)
		echo 'Starting.'
		;;
	stop)
		echo 'Stopping.'
		;;
	status|state|--status|--state)
		echo 'Status:'
		;;
	*)
		echo 'Supply a valid option.' 1>&2
		exit 1
		;;
esac
