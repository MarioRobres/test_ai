#!/usr/bin/env bash

set -e
set -u

echo "Script execution started"

echo "Current date and time:"
date "+%Y-%m-%d %H:%M:%S"

echo "System information:"
uname -a

echo "Current user:"
whoami

echo "Working directory:"
pwd

echo "Script execution finished"
