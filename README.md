## Letsencrypt certbot docker image
Let’s Encrypt is a free, automated, and open Certificate Authority.

This image is based on [ppa:certbot/certbot](https://launchpad.net/~certbot/+archive/ubuntu/certbot) packages for Ubuntu Xenial and is built on top of [clover/python](https://hub.docker.com/r/clover/python/).

By default, the container will only renew certificates every day in a _webroot_ mode.

### Data volumes
| Location | Description |
|---|---|
| `/etc/letsencrypt` | certificates, private keys and _certbot_ configuration files |
| `/var/www/.well-known/acme-challenge` | (not exported) acme challenges in _webroot_ mode |
| `/var/log/letsencrypt` | (not exported) _certbot_ log files |
| `/var/lib/letsencrypt` | (not exported) _certbot_ working directory |

`PUID`/`PGID` owner will be recursively set to all directories listed above at startup.

### Exposed ports
| Port | Description |
|---|---|
| `80` | HTTP in a _standalone_ web server mode _*_ |
| `443` | HTTPS in a _standalone_ web server mode _*_ |

_*_ _webroot_ mode is used by default, there are no processes listening on ports above.

### Enviroment variables
| Name | Default value | Description |
|---|---|---|
| `PUID` | `50` | Desired _UID_ of the process owner _**_ |
| `PGID` | primary group id of the _UID_ user (`50`) | Desired _GID_ of the process owner _**_ |

_**_ `PUID`/`PGID` could be used to preserve data volume ownership on host.

### Configuration files
| Location | Description |
|---|---|
| `/etc/letsencrypt/cli.ini` | Default _certbot_ configuration |
