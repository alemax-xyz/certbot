#
# This is a multi-stage build.
# Actual build is at the very end.
#

FROM library/ubuntu:xenial AS build

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
RUN apt-get update && \
    apt-get install -y \
        python-software-properties \
        software-properties-common \
        apt-utils
RUN add-apt-repository -y ppa:certbot/certbot && \
    apt-get update

RUN mkdir -p /build/image
WORKDIR /build
RUN apt-get download \
        libpipeline1 \
        ca-certificates \
        dialog \
        tzdata \
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
RUN for file in *.deb; do dpkg-deb -x ${file} image/; done

WORKDIR /build/image
RUN rm -rf \
        etc/ca-certificates \
        etc/cron* \
        lib/systemd \
        usr/include \
        usr/share/doc \
        usr/share/doc-base \
        usr/share/lintian \
        usr/share/locale \
        usr/share/man \
        usr/share/perl5 \
        usr/sbin && \
    cat usr/share/ca-certificates/mozilla/*.crt > etc/ssl/certs/ca-certificates.crt

FROM clover/python-base:2.7

WORKDIR /
COPY --from=build /build/image /

CMD ["certbot", "renew"]

EXPOSE 80
