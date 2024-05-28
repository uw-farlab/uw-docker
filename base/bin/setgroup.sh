#!/bin/bash

# Set defaults 
USER_NAME=${USER_NAME:-cuser}
USER_ID=${USER_ID:-1000}
GROUP_NAME=${GROUP_NAME:-cdata}
GROUP_ID=${GROUP_ID:-1000}

# This sets up the requested GROUP_NAME and GROUP_ID
#echo ${USER_NAME} ${USER_ID} ${GROUP_NAME} ${GROUP_ID}

# See if a GROUP_ID exists?
if [ $(getent group ${GROUP_ID}) ]; then
    # See if the name matches
    IFS=":" read -ra GROUPDATA <<< `getent group ${GROUP_ID}`
    CGROUP_NAME=${GROUPDATA[0]}

    # If the group name does not match, replace it in /etc/group
    if [ "${CGROUP_NAME}x" != "${GROUP_NAME}x" ]; then
        echo "WARNING: Replacing group name in /etc/group."
	echo ${CGROUP_NAME} ${GROUP_NAME}
	sed -i 's/^'"${CGROUP_NAME}"':/'"${GROUP_NAME}"':/' /etc/group
    fi
else
    addgroup --gid ${GROUP_ID} ${GROUP_NAME}
fi
