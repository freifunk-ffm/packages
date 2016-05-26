#!/bin/sh

iw dev client0 survey dump > /tmp/24dump
if [ $? -eq 0 ]; then
  cat /tmp/24dump | sed '/Survey/,/\[in use\]/d'  > /tmp/24reduced
  ACTIVE_CUR=$(ACTIVE=$(cat /tmp/24reduced | grep "active time:"); set ${ACTIVE:-0 0 0 0 0}; echo -e "${4}")
  BUSY_CUR=$(BUSY=$(cat /tmp/24reduced | grep "busy time:"); set ${BUSY:-0 0 0 0 0}; echo -e "${4}")
  echo $ACTIVE_CUR > /tmp/active2
  echo $BUSY_CUR > /tmp/busy2
fi

iw dev client1 survey dump > /tmp/5dump
if [ $? -eq 0 ]; then
  cat /tmp/5dump | sed '/Survey/,/\[in use\]/d'  > /tmp/5reduced
  ACTIVE_CUR=$(ACTIVE=$(cat /tmp/5reduced | grep "active time:"); set ${ACTIVE:-0 0 0 0 0}; echo -e "${4}")
  BUSY_CUR=$(BUSY=$(cat /tmp/5reduced | grep "busy time:"); set ${BUSY:-0 0 0 0 0}; echo -e "${4}")
  echo $ACTIVE_CUR > /tmp/active5
  echo $BUSY_CUR > /tmp/busy5
fi
