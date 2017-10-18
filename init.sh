#!/bin/sh

test -z "$PUID" && PUID=50 || test "$PUID" -eq "$PUID" || exit 2
PUSER=$(getent passwd $PUID | cut -d: -f1)
if [ -z "$PUSER" ]; then
    PUSER=$(getent passwd 50 | cut -d: -f1) && usermod --uid $PUID "$PUSER" || exit 2
fi

test -z "$PGID" && PGID=$(id -g "$PUSER") || test "$PGID" -eq "$PGID" || exit 2
PGROUP=$(getent group $PGID | cut -d: -f1)
if [ -z "$PGROUP" ]; then
	PGROUP=$(id -gn "$PUSER")
	groupmod --gid $PGID "$PGROUP" || exit 2
else
	test $(id -g "$PUSER") -eq $PGID || usermod --gid $PGID "$PUSER" || exit 2
fi

chown $PUID:$PGID /www/.well-known /www/.well-known/acme-challenge /etc/letsencrypt /var/log/letsencrypt /var/lib/letsencrypt || exit 2

cron -f
