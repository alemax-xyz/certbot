#!/bin/sh

chown -R $PUID:$PGID \
	/etc/letsencrypt \
	/var/www/.well-known \
	/var/log/letsencrypt \
	/var/lib/letsencrypt || exit 2
