FROM docker.io/library/alpine:3.22
RUN apk add --no-cache ca-certificates
COPY webhook /usr/local/bin/webhook
ENTRYPOINT ["/usr/local/bin/webhook"]
