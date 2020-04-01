#!/bin/sh

set -xe

if hash su-exec 2>/dev/null; then
  export RUNEXEC=su-exec
else
  export RUNEXEC=gosu
fi

# COPY config.conf config.conf

USER_ID=${UID}
GROUP_ID=${GID}

echo "Setting permissions to UID/GID: ${USER_ID}/${GROUP_ID}"
chown ${USER_ID}:${GROUP_ID} -R /hayden
chown ${USER_ID}:${GROUP_ID} ${SCRAPER_IMGDIR}

exec ${RUNEXEC} ${USER_ID}:${GROUP_ID} "$@"
