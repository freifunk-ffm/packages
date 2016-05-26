#!/bin/sh

iw dev client0 survey dump > /tmp/24dump
if [ $? -eq 0 ]; then
  cat /tmp/24dump | sed '/Survey/,/\[in use\]/d'  > /tmp/24reduced
  ACT_CUR=$(ACTIVE=$(cat /tmp/24reduced | grep "active time:"); set ${ACTIVE:-0 0 0 0 0}; echo -e "${4}")
  BUS_CUR=$(BUSY=$(cat /tmp/24reduced | grep "busy time:"); set ${BUSY:-0 0 0 0 0}; echo -e "${4}")
  echo $ACT_CUR > /tmp/act2
  echo $BUS_CUR > /tmp/bus2
fi

iw dev client1 survey dump > /tmp/5dump
if [ $? -eq 0 ]; then
  cat /tmp/5dump | sed '/Survey/,/\[in use\]/d'  > /tmp/5reduced
  ACT_CUR=$(ACTIVE=$(cat /tmp/5reduced | grep "active time:"); set ${ACTIVE:-0 0 0 0 0}; echo -e "${4}")
  BUS_CUR=$(BUSY=$(cat /tmp/5reduced | grep "busy time:"); set ${BUSY:-0 0 0 0 0}; echo -e "${4}")
  echo $ACT_CUR > /tmp/act5
  echo $BUS_CUR > /tmp/bus5
fi