#!/bin/sh
##
## Run the daemon (SABnzbd)
##
## Environment Variables:
##  PUID ... unprivileged UID
##  PGID ... unprivileged GID
##

user="dlmanager"
group="dlmanager"
if ! id ${user} >/dev/null 2>&1; then 
	addgroup -g "${PGID:=100000}" "${group}"
	adduser -h / -H -D -G "${group}" -u "${PUID:=100000}" "${user}"
fi

chown -R ${user}:${group} /config

# Run SABnzbd in foreground
exec su - ${user} -c \
	'/opt/sabnzbd/SABnzbd.py --config-file /config --server 0.0.0.0:8080'

