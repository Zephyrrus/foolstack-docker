FROM mcr.microsoft.com/dotnet/core/sdk:3.1 as builder
ARG ARCH=linux-musl-x64
ADD https://api.github.com/repos/Zephyrrus/Hayden/git/refs/heads/develop /version.json
RUN git clone --single-branch --branch develop https://github.com/Zephyrrus/Hayden /build && cd /build && dotnet publish Hayden -r $ARCH -o /hayden

FROM alpine:latest
ENTRYPOINT ["sh", "/hayden/entrypoint.sh"]
CMD ["/hayden/Hayden", "/hayden/data/config.json"]
WORKDIR /hayden

RUN apk add --update --no-cache libstdc++ glib icu-libs libcurl su-exec libintl && \
    apk add --update --no-cache gettext && cp /usr/bin/envsubst /usr/local/bin/envsubst && apk del gettext && \
    mkdir /boards
COPY --from=builder /hayden /hayden
COPY entrypoint.sh  /hayden/

VOLUME /boards

ENV UID=${UID:-1000} \
    GID=${GID:-1000} \
    SCRAPER_IMGDIR=/boards
