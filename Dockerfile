FROM alpine:latest

ARG BUILD_DATE

# first, a bit about this container
LABEL build_info="gpsd build-date:- ${BUILD_DATE}"
LABEL maintainer="Donald Kaulukukui"
LABEL documentation="None"

# install chrony
RUN apk add --no-cache gpsd

# script to configure/startup gpsd
#COPY assets/startup.sh /opt/startup.sh

# ntp port
EXPOSE 2947

# start chronyd in the foreground
ENTRYPOINT ["/bin/sh", "-c", "/sbin/syslogd -S -O - -n & exec /usr/sbin/gpsd -N -n -G ${*}","--"]
