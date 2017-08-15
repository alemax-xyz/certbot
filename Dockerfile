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
        certbot \
        python \
        python2.7 \
        python-minimal \
        python2.7-minimal \
        libpython-stdlib \
        libpython2.7-stdlib \
        libpython2.7-minimal \
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
        ca-certificates \
        dialog \
        tzdata \
        mime-support \
        libbz2-1.0 \
        libdb5.3 \
        libexpat1 \
        libffi6 \
        libncursesw5 \
        libreadline6 \
        libsqlite3-0 \
        libssl1.0.0 \
        libtinfo5 \
        libpipeline1 \
        zlib1g
RUN for file in *.deb; do dpkg-deb -x ${file} image/; done

WORKDIR /build/image
RUN rm -rf \
        etc/ca-certificates \
        etc/cron* \
        etc/default \
        etc/init \
        etc/init.d \
        etc/python2.7 \
        etc/ssl \
        lib/systemd \
        usr/bin/cautious-launcher \
        usr/bin/compose \
        usr/bin/edit \
        usr/bin/print \
        usr/bin/run-mailcap \
        usr/bin/see \
        usr/include \
        usr/lib/mime \
        usr/share/applications \
        usr/share/apps \
        usr/share/bug \
        usr/share/debhelper \
        usr/share/doc \
        usr/share/doc-base \
        usr/share/lintian \
        usr/share/locale \
        usr/share/man \
        usr/share/perl5 \
        usr/share/pixmaps \
        usr/share/binfmts \
        usr/sbin

FROM clover/base

WORKDIR /
COPY --from=build /build/image /

CMD ["certbot", "renew"]

EXPOSE 80
