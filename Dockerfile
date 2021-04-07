ARG DISTRO=alpine:3
FROM $DISTRO

ARG GITHUB_PROJECT="sabnzbd/sabnzbd"
ARG APP_ROOT="/opt/sabnzbd"

RUN \
  apk update && \
  apk upgrade && \
  apk add --no-cache tzdata curl jq python3 py3-six py3-chardet && \
  apk add --no-cache py3-pip python3-dev gcc musl-dev libffi-dev openssl-dev py3-wheel rust cargo && \
  apk add --no-cache unrar unzip p7zip && \
  apk add --no-cache clamav-clamdscan && \
  echo "------ !!! Installing par2cmdline from edge/testing !!! ------" && \
  apk add par2cmdline --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
  mkdir -p "$APP_ROOT" && \
  RELEASE_TARBALL=$( curl -s "https://api.github.com/repos/${GITHUB_PROJECT}/releases/latest" | jq -r '.tarball_url' ); \
  curl -s -L -H "Accept: application/vnd.github.v3+json" "${RELEASE_TARBALL}" | tar -xz -C "${APP_ROOT}" --strip-components=1 && \
  pip install --no-cache-dir -r "${APP_ROOT}/requirements.txt" -U && \
  cd ${APP_ROOT} && \
  python3 "${APP_ROOT}/tools/make_mo.py" && \
  cd - && \
  apk del --purge -r python3-dev gcc musl-dev libffi-dev openssl-dev py3-wheel py3-pip jq curl rust cargo && \
  rm -rf /root/.cache && \
  rm -rf /root/.cargo && \
  rm -rf /var/cache/apk/*
  
COPY root/ /

VOLUME ["/config"]
EXPOSE 8080/tcp

CMD /run.sh

