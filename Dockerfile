FROM golang:1.9 as builder

## Create a directory and Add Code
RUN mkdir -p /go/src/github.com/orvice/uping
WORKDIR /go/src/github.com/orvice/uping
ADD .  /go/src/github.com/orvice/uping

# Download and install any required third party dependencies into the container.
RUN go-wrapper download
# RUN go-wrapper install
RUN CGO_ENABLED=0 go build


# Now tell Docker what command to run when the container starts
# CMD ["go-wrapper", "run"]

FROM alpine

COPY --from=builder /go/src/github.com/orvice/uping/uping .

RUN apk update
RUN apk upgrade
RUN apk add ca-certificates && update-ca-certificates
# Change TimeZone
RUN apk add --update tzdata
ENV TZ=Asia/Shanghai
# Clean APK cache
RUN rm -rf /var/cache/apk/*

EXPOSE 8080

ENTRYPOINT [ "./uping" ]