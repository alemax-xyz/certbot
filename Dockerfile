FROM clover/base AS base

RUN groupadd \
        --gid 50 \
        --system \
        certbot \
 && useradd \
        --home-dir /var/lib/letsencrypt \
        --no-create-home \
        --system \
        --shell /bin/false \
        --uid 50 \
        --gid 50 \
        certbot

FROM library/ubuntu:xenial AS build

ENV LANG=C.UTF-8

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y \
        python-software-properties \
        software-properties-common \
        apt-utils

RUN export DEBIAN_FRONTEND=noninteractive \
 && add-apt-repository -y ppa:certbot/certbot \
 && apt-get update

RUN mkdir -p /build /rootfs
WORKDIR /build
RUN apt-get download \
        libpipeline1 \
        dialog \
        python-certbot \
        python-acme \
        python-dialog \
        python-dnspython \
        python-ndg-httpsclient \
        python-requests \
        python-configargparse \
        python-configobj \
        python-cryptography \
        python-enum34 \
        python-idna \
        python-ipaddress \
        python-pyasn1 \
        python-cffi-backend \
        python-chardet \
        python-pkg-resources \
        python-mock \
        python-funcsigs \
        python-pbr \
        python-openssl \
        python-parsedatetime \
        python-rfc3339 \
        python-setuptools \
        python-six \
        python-tz \
        python-urllib3 \
        python-zope.component \
        python-zope.event \
        python-zope.interface \
        certbot
RUN find *.deb | xargs -I % dpkg-deb -x % /rootfs

WORKDIR /rootfs
RUN rm -rf \
        etc/cron* \
        lib/systemd \
        usr/include \
        usr/share/doc \
        usr/share/doc-base \
        usr/share/lintian \
        usr/share/locale \
        usr/share/man \
        usr/share/perl5 \
 && mkdir -p \
        www/.well-known/acme-challenge \
        var/log/letsencrypt \
        var/lib/letsencrypt \
 && touch www/.well-known/acme-challenge/.keep

COPY --from=base /etc/group /etc/gshadow /etc/passwd /etc/shadow etc/
COPY certbot etc/cron.d/
COPY init.sh etc/
COPY cli.ini etc/letsencrypt/

WORKDIR /


FROM clover/python:2.7

ENV LANG=C.UTF-8

COPY --from=build /rootfs /

VOLUME ["/etc/letsencrypt"]

CMD ["sh", "/etc/init.sh"]

EXPOSE 80 443
