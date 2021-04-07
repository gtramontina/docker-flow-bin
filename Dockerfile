FROM node:10.24.1-alpine

ARG glibcVersion=2.29-r0

RUN wget -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub &&\
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$glibcVersion/glibc-$glibcVersion.apk && \
    apk add glibc-$glibcVersion.apk && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

WORKDIR /opt
ENV PATH="/opt/node_modules/.bin:${PATH}"

COPY package.json .
COPY yarn.lock .
RUN yarn --prod && \
    yarn autoclean --init && \
    yarn autoclean --force && \
    rm package.json yarn.lock .yarnclean

ENTRYPOINT ["flow"]
CMD ["--help"]
