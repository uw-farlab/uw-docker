#!/bin/bash

# NOTE: This is invoked by sudo(root)

# Adjust container account if needed

USER_ID=${USER_ID:-1000}
GROUP_ID=${GROUP_ID:-1000}
USER_NAME=${USER_NAME:-cuser}
GROUP_NAME=${GROUP_NAME:-cdata}

echo ${USER_NAME} ${USER_ID} ${GROUP_NAME} ${GROUP_ID}

# Establish group
if [ ! $(getent group ${GROUP_ID}) ]; then
  if [ ! $(getent group ${GROUP_NAME}) ]; then
    CGROUP_NAME=`cat /etc/container.group`
    if [ "${CGROUP_NAME}x" != "${GROUP_NAME}" ]; then
      addgroup --gid ${GROUP_ID} ${GROUP_NAME}
    fi
  fi
fi

# Establish user
if [ ! $(getent passwd ${USER_ID}) ]; then
    if [ ! $(getent passwd ${USER_NAME}) ]; then
    CUSER_NAME=`cat /etc/container.user`
    if [ "${CUSER_NAME}x" != "${USER_NAME}x" ]; then
      adduser --system --uid ${USER_ID} --gid ${GROUP_ID} --gecos "" \
        --home /home/${USER_NAME} ${USER_NAME}
      cd /home
      mv ${USER_NAME} tmp
      mv ${CUSER_NAME} ${USER_NAME}
      ln -s ${USER_NAME} ${CUSER_NAME}
      chown -R ${USER_ID}:${GROUP_ID} ${USER_NAME}
      # Update .bashrc
      cd /home/${USER_NAME}
      sed -i 's/\/home\/'"${CUSER_NAME}"'/\/home\/'"${USER_NAME}"'/g' .bashrc
      # Add sudo to ${USER_NAME}
      echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    fi
  fi
fi
