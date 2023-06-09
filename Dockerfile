ARG         base=alpine:3.18

###

FROM        ${base} as build

ARG         version=
ARG         repo=GNOME/libxslt

RUN         apk add --no-cache --virtual .build-deps \
                autoconf \
                libtool \
                automake \
                libxml2-dev \
                python3-dev \
                build-base && \
            wget -O - https://github.com/${repo}/archive/refs/tags/v${version}.tar.gz | tar xz

RUN         cd libxslt-${version} && \
            ./autogen.sh && \
            make && \
            make install

###

FROM        ${base}

COPY        --from=build /usr/local/bin /usr/local/bin
COPY        --from=build /usr/local/include /usr/local/include
COPY        --from=build /usr/local/lib /usr/local/lib

RUN         apk add --no-cache --virtual .run-deps \
                libxml2

ENTRYPOINT  ["xsltproc"]
