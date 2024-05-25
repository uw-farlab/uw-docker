#!/bin/bash

# Perform initial shell setup for the container
# based on USER_ID and GROUP_ID arguments
# ** PERFORM THIS STEP ONLY ONCE **
if [ ! -f /initialized.txt ]; then

  USER_ID=${USER_ID:-1000}
  GROUP_ID=${GROUP_ID:-1000}
  USER_NAME=${USER_NAME:-cuser}
  GROUP_NAME=${GROUP_NAME:-cdata}

  # Establish group
  if [ ! $(getent group ${GROUP_ID}) ]; then
    if [ ! $(getent group ${GROUP_NAME}) ]; then
      groupadd -r ${GROUP_NAME} -g ${GROUP_ID}
    fi
  fi

  # Establish user
  if [ ! $(getent passwd ${USER_ID}) ]; then
    if [ ! $(getent passwd ${USER_NAME}) ]; then
      useradd -m -r -u ${USER_ID} -g ${GROUP_NAME} -d /home/${USER_NAME} -s /bin/bash \
        -c "Data user" ${USER_NAME}
    fi
  fi

  # Convert /root directory to allow access to installed
  # container software
  #chown -R ${USER_ID}:${GROUP_ID} /root
  chmod 755 /root
  cp /root/.bashrc /home/${USER_NAME}/.bashrc
  chmod ${USER_ID}:${GROUP_ID} /home/${USER_NAME}/.bashrc

  touch /initialized.txt
fi

while true; do
  sleep 100
done
