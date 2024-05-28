#!/bin/bash

# Perform initial shell setup for the container
# based on USER_ID and GROUP_ID arguments
# ** PERFORM THIS STEP ONLY ONCE **
if [ ! -f /initialized.txt ]; then

  sudo -E /chkacct.sh 2>&1 chkacct.log

  sudo touch /initialized.txt
fi

while true; do
  sleep 100
done
