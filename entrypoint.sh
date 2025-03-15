#!/bin/bash

echo "Starting 5 freeDiameterd instances..."

# Start the instances of freeDiameter
/usr/local/bin/freeDiameterd -c /conf/dra1.conf -dd > /tmp/dra1.log 2>&1 &
PID1=$!
sleep 2
/usr/local/bin/freeDiameterd -c /conf/freeDiameter11.conf -dd > /tmp/peer11.log 2>&1 &
PID2=$!
sleep 2
/usr/local/bin/freeDiameterd -c /conf/freeDiameter12.conf -dd > /tmp/peer12.log 2>&1 &
PID3=$!
sleep 2
/usr/local/bin/freeDiameterd -c /conf/dra2.conf -dd > /tmp/dra2.log 2>&1 &
PID4=$!
sleep 2
/usr/local/bin/freeDiameterd -c /conf/freeDiameter2.conf -dd > /tmp/peer2.log 2>&1 &
PID5=$!

echo "=== freeDiameterd processes:"
echo "    freeDiameterd dra1:" $PID1
echo "    freeDiameterd peer11:" $PID2
echo "    freeDiameterd peer12:" $PID3
echo "    freeDiameterd dra2:" $PID4
echo "    freeDiameterd peer2:" $PID5
echo "=== Their logs are in /tmp/*.log"
echo "=== To test, run:"
echo "    tail -f /tmp/peer11.log &"
echo "    tail -f /tmp/peer12.log &"
echo "    kill -10" $PID5
echo "=== Depending on the verbose level, one of these messages should show up in either peer11 or peer12 log:"
echo "    > ECHO Test-Request received from 'peer11.left.side', replying... <"
echo "or:"
echo "    > RECV 2ae8944a (Ok) Status: 2001 From 'peer12.left.side' ('left.side')... <"

# Start bash interactively
exec bash
