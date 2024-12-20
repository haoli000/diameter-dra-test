#!/bin/bash

echo "Starting 4 freeDiameterd instances..."

# Start the instances of freeDiameter
/usr/local/bin/freeDiameterd -c /conf/dra1.conf -d > /tmp/dra1.log 2>&1 &
PID1=$!
sleep 1
/usr/local/bin/freeDiameterd -c /conf/freeDiameter1.conf -d > /tmp/peer1.log 2>&1 &
PID2=$!
sleep 1
/usr/local/bin/freeDiameterd -c /conf/dra2.conf -d > /tmp/dra2.log 2>&1 &
PID3=$!
sleep 1
/usr/local/bin/freeDiameterd -c /conf/freeDiameter2.conf -d > /tmp/peer2.log 2>&1 &
PID4=$!

echo "=== freeDiameterd processes:"
echo "    freeDiameterd dra1:" $PID1
echo "    freeDiameterd peer1:" $PID2
echo "    freeDiameterd dra2:" $PID3
echo "    freeDiameterd peer2:" $PID4
echo "=== Their logs are in /tmp/*.log"
echo "=== To test, run:"
echo "    tail -f /tmp/peer1.log &"
echo "    kill -10" $PID4
echo "=== This message should show up:"
echo "    > ECHO Test-Request received from 'peer2.localdomain', replying... <"

# Start bash interactively
exec bash
