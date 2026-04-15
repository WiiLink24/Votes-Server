FROM golang:1.25-alpine as builder

# We assume only git is needed for all dependencies.
# openssl is already built-in.
RUN apk add -U --no-cache git

WORKDIR /opt/wiilink/evc/Votes-Server/

# Cache pulled dependencies if not updated.
COPY go.mod .
COPY go.sum .
RUN go mod download

# Copy source into builder's source
COPY *.go ./

# Build to name "app".
RUN go build -o app .

FROM alpine:latest

WORKDIR /opt/wiilink/evc/Votes-Server/

COPY --from=builder /opt/wiilink/evc/Votes-Server/app .

EXPOSE 8003
CMD ["./app"]
