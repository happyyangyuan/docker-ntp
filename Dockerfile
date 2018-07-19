FROM alpine:latest

# install openntp
RUN apk add --no-cache openntpd

# use custom ntpd config file
COPY assets/ntpd.conf /etc/ntpd.conf

# ntp port
EXPOSE 123/udp

RUN apk add -U tzdata
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# start ntpd in the foreground
ENTRYPOINT [ "/usr/sbin/ntpd", "-v", "-d", "-s" ]
