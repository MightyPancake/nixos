#!/usr/bin/env bash
DEVICE="80:99:E7:2D:A0:48"

bluetoothctl power on
bluetoothctl connect "$DEVICE"
