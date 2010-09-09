#!/bin/bash

ogg_123_options="$@"

LOG_TOPIC="ogg-123"
LOG_TOPIC_OUT="$LOG_TOPIC[$$]"
LOG_TOPIC_ERR="$LOG_TOPIC-err[$$]"

exec > >(logger -t "$LOG_TOPIC_OUT")
exec 2> >(logger -t "$LOG_TOPIC_ERR" )

while [ true ]; do
  /usr/bin/ogg123 --quiet $ogg_123_options &

  ogg123_pid=$!
  trap "kill -9 $ogg123_pid; exit 0" INT TERM EXIT
  wait $!
  trap - INT TERM EXIT

  echo "ogg123 has been stopped, restart"
  sleep 5
done
