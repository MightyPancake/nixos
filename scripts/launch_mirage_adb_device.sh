#!/usr/bin/env bash

AVD_NAME="mirage-test"

if pgrep -f "emulator.*-avd $AVD_NAME" >/dev/null; then
  echo "$AVD_NAME emulator is already running."
  exit 0
fi

setsid emulator -avd "$AVD_NAME" >/dev/null 2>&1 &
disown
echo "Launching $AVD_NAME emulator..."
