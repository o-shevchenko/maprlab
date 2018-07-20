#!/bin/sh

# The environment variables in this file are for example only. These variables
# must be altered to match your docker container deployment needs

# MapR cluster admin user / group
MAPR_CONTAINER_USER=mapr
MAPR_CONTAINER_UID=5000
MAPR_CONTAINER_GROUP=mapr
MAPR_CONTAINER_GID=5000
MAPR_PKG_URL=http://package.mapr.com/releases
MAPR_CONTAINER_PASSWORD=

# MapR stanza file path on host
MAPR_STANZA_FILE=
# MapR stanza file path in container
MAPR_STANZAFILE_LOCATION=
[ -z "$MAPR_STANZAFILE_LOCATION" ] && [ -n "$MAPR_STANZA_FILE" ] && MAPR_STANZAFILE_LOCATION="/tmp/$(basename $MAPR_STANZA_FILE)"

# Container memory: specify host XX[kmg] or 0 for no limit. Ex: 8192m, 12g
MAPR_MEMORY=0

# Container timezone: filename from /usr/share/zoneinfo
MAPR_TZ=${TZ:-""}

# Container network mode: "host" causes the container's sshd service to conflict
# with the host's sshd port (22) and so it will not be enabled in that case
MAPR_DOCKER_NETWORK=bridge

# Container security: --privileged or --cap-add SYS_ADMIN /dev/<device>
MAPR_DOCKER_SECURITY=""

# Other Docker run args:
MAPR_DOCKER_ARGS="-p 9443:9443 "

### do not edit below this line ###
grep -q -s DISTRIB_ID=Ubuntu /etc/lsb-release && \
  MAPR_DOCKER_SECURITY="$MAPR_DOCKER_SECURITY --security-opt apparmor:unconfined"

MAPR_DOCKER_ARGS="$MAPR_DOCKER_SECURITY \
  --memory $MAPR_MEMORY \
  --network=$MAPR_DOCKER_NETWORK \
  -e MAPR_DISKS=$MAPR_DISKS \
  -e MAPR_CLUSTER=$MAPR_CLUSTER \
  -e MAPR_LICENSE_MODULES=$MAPR_LICENSE_MODULES \
  -e MAPR_MEMORY=$MAPR_MEMORY \
  -e MAPR_MOUNT_PATH=$MAPR_MOUNT_PATH \
  -e MAPR_SECURITY=$MAPR_SECURITY \
  -e MAPR_TZ=$MAPR_TZ \
  -e MAPR_USER=$MAPR_USER \
  -e MAPR_CONTAINER_USER=$MAPR_CONTAINER_USER \
  -e MAPR_CONTAINER_UID=$MAPR_CONTAINER_UID \
  -e MAPR_CONTAINER_GROUP=$MAPR_CONTAINER_GROUP \
  -e MAPR_CONTAINER_GID=$MAPR_CONTAINER_GID \
  -e MAPR_CONTAINER_PASSWORD=$MAPR_CONTAINER_PASSWORD \
  -e MAPR_CLDB_HOSTS=$MAPR_CLDB_HOSTS \
  -e MAPR_HS_HOST=$MAPR_HS_HOST \
  -e MAPR_OT_HOSTS=$MAPR_OT_HOSTS \
  -e MAPR_ZK_HOSTS=$MAPR_ZK_HOSTS \
  $MAPR_DOCKER_ARGS"

[ -f "$MAPR_TICKET_FILE" ] && MAPR_DOCKER_ARGS="$MAPR_DOCKER_ARGS \
  -e MAPR_TICKETFILE_LOCATION=$MAPR_TICKETFILE_LOCATION \
  -v $MAPR_TICKET_FILE:$MAPR_TICKETFILE_LOCATION:ro"
[ -d /sys/fs/cgroup ] && MAPR_DOCKER_ARGS="$MAPR_DOCKER_ARGS -v /sys/fs/cgroup:/sys/fs/cgroup:ro"

MAPR_STANZA_ARGS="$@"

[ -f "$MAPR_STANZA_FILE" ] && MAPR_DOCKER_ARGS="$MAPR_DOCKER_ARGS \
  -e MAPR_STANZAFILE_LOCATION=$MAPR_STANZAFILE_LOCATION \
  -v $MAPR_STANZA_FILE:$MAPR_STANZAFILE_LOCATION:ro"

MAPR_DOCKER_ARGS="$MAPR_DOCKER_ARGS -e MAPR_PKG_URL=$MAPR_PKG_URL"
docker run -it $MAPR_DOCKER_ARGS maprtech/installer:ubuntu16 $MAPR_STANZA_ARGS
