#!/usr/bin/env bash

set -e
set -u


echo "Current date and time:"
date "+%Y-%m-%d %H:%M:%S"

echo "System information:"
uname -a

echo "Current user:"
whoami

echo "Working directory:"
pwd

echo "Script execution finished"

# Typo in my commment
echo "Script execution started"

for i in {1..10}; do
    echo "$i"
done

# Not same tabulation
for i in {1..10}; do
  echo "$i"
done

# Bad command
echo "Bad command
