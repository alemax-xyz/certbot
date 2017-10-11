#!/bin/sh

test -z "$PUID" && PUID=50 || test "$PUID" -eq "$PUID" || exit 2
test -z "$PGID" && PGID=$(id -g $PUID) || test "$PGID" -eq "$PGID" || exit 2

PUSER=$(id -un $PUID 2>/dev/null)
test -n "$PUSER" || PUSER=$(id -un 50) || usermod --uid $PUID "$PUSER" || exit 2

PGROUP=$(getent group $PGID | cut -d: -f1)
if [ -z "$PGROUP" ]; then
	PGROUP=$(id -gn $PUID)
	groupmod --gid $PGID "$PGROUP" || exit 2
else
	test $(id -g $PUID) -eq $PGID || usermod --gid $PGID "$PUSER" || exit 2
fi

echo $PUID $PGID $PUSER $PGROUP

chown $PUID:$PGID -R /www/.well-known/acme-challenge /etc/letsencrypt /var/log/letsencrypt /var/lib/letsencrypt || exit 2

cron -f
