#!/usr/bin/env bash

DEVICE="80:99:E7:2D:A0:48"

# Start scanning in the background.
# We pipe 'sleep 60' into it so bluetoothctl stays open (and scanning) 
# for 60 seconds or until we kill it.
{ echo "scan on"; sleep 60; } | bluetoothctl > /dev/null 2>&1 &
SCAN_PID=$!
disown

# Give the scanner a moment to initialize
sleep 2

echo "Waiting..."

for i in {1..20}; do
    # Try to connect. We capture output to check for success.
    if bluetoothctl connect "$DEVICE" 2>&1 | grep -q "Connection successful"; then
        echo "Connected"
        # Kill the background scanner process since we are done
        kill $SCAN_PID > /dev/null 2>&1
        exit 0
    fi
    
    echo "Waiting..."
    sleep 2
done

# If we reach here, we failed. Clean up the scanner.
kill $SCAN_PID > /dev/null 2>&1
echo "Failed to connect"
exit 1
