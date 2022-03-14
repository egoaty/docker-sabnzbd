#ARG DISTRO=alpine:3
ARG DISTRO=ubuntu
FROM $DISTRO

ARG GITHUB_PROJECT="sabnzbd/sabnzbd"
ARG APP_ROOT="/opt/sabnzbd"

RUN \
  apt-get update && \
  apt-get dist-upgrade -q -y && \
  \
  export DEBIAN_FRONTEND=noninteractive && \
  ln -fs /usr/share/zoneinfo/Europe/Vienna /etc/localtime && \
  apt-get install -y tzdata && \
  dpkg-reconfigure --frontend noninteractive tzdata && \
  \
  apt-get install -y software-properties-common curl jq && \
  \
  add-apt-repository ppa:jcfp/nobetas && \
  apt-get update && \
  apt-get dist-upgrade -q -y && \
  apt-get install -y sabnzbdplus && \
  \
  apt-get install -y clamdscan && \
  \
  apt-get remove --purge -y software-properties-common && \
  apt-get clean -q -y --force-yes && \
  apt-get autoclean -q -y --force-yes
  
COPY root/ /

VOLUME ["/config"]
EXPOSE 8080/tcp

CMD /run.sh

