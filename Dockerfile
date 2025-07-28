#
FROM docker.io/library/golang:1.24.5-alpine3.22 AS build_deps

RUN apk add --no-cache git

WORKDIR /workspace

COPY go.mod .
COPY go.sum .

RUN go mod download -x

FROM build_deps AS build

COPY . .

ENV CGO_ENABLED="0"
ENV GOARCH=""
RUN go build \
    -ldflags '-w -extldflags "-static"' \
    -o webhook \
    -v \
    .

FROM alpine:3.22

RUN apk add --no-cache ca-certificates

COPY --from=build /workspace/webhook /usr/local/bin/webhook

ENTRYPOINT ["/usr/local/bin/webhook"]
