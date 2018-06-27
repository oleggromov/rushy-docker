FROM node:8-alpine
MAINTAINER Oleg Gromov <hi@oleggromov.com>

# Install chromium
ENV CHROME_BIN=/usr/bin/chromium-browser
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache \
      grep \
      chromium@edge \
      nss@edge

# Install rushy
RUN yarn global add rushy && \
  mkdir -p /var/rushy/front/lighthouse-reports

WORKDIR /var/rushy
CMD rushy \
    --config=/var/config/$RUSHY_CONFIG \
    --worker=$RUSHY_WORKER \
    --worker-count=$RUSHY_WORKER_COUNT
