# Notes

## Customization

Some containers allow customization of four environment variables that
can be overridden to allow matching UID/GIDs of the user utilizing
these containers for work.  The four environment variables are:

 * `USER_NAME`: The user name for the container (default: cuser).
 * `GROUP_NAME`: The group name for the container (default: cdata).
 * `USER_ID`: The user id for the container (default: 1000).
 * `GROUP_ID`: The groud id for the container (default: 1000).

NOTE: These variables in bash need to be exported prior to running
sudo to allow them to be passed to docker.  Do not pass empty
environment variables.

```bash
export USER_NAME=${USER}
export GROUP_ID=`id -g`
export USER_ID=`id -u`
IFS=":" read -ra GROUPDATA <<< `getent group ${GROUP_ID}`
export GROUP_NAME=${GROUPDATA[0]}
```
