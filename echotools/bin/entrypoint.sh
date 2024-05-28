#!/bin/bash

# Perform initial shell setup for the container
# based on USER_ID and GROUP_ID arguments
# ** PERFORM THIS STEP ONLY ONCE **
# Log messages may be obtained using:
# docker container logs <container-name>
if [ ! -f /initialized.txt ]; then
  echo "START: Initializing container for first use."

  sudo -E /chkacct.sh 2>&1 chkacct.log

  sudo touch /initialized.txt
  echo "DONE: Container initialized."
fi

while true; do
  sleep 100
done
