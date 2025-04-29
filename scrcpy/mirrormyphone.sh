#!/bin/bash

# Function to check if ADB server is running
check_adb_server() {
  if ! lsof -i :5037 > /dev/null; then
    echo "🔄 ADB server not running. Starting ADB..."
    adb start-server
  else
    echo "✅ ADB server is already running."
  fi
}

restart_adb_server() {
  adb kill-server
  adb start-server
  sleep 1
}

# Function to (re)connect via USB
connect_usb() {
  SCRCPY_OPTIONS="$@"

  CONNECT_OUTPUT=$(scrcpy "$SCRCPY_OPTIONS" 2>&1)

  echo "$CONNECT_OUTPUT"

  if echo "$CONNECT_OUTPUT" | grep -q "ERROR: Server connection failed"; then
    echo "❌ ERROR: Server connection failed. Restarting adb server and retrying..."
    restart_adb_server
    scrcpy $SCRCPY_OPTIONS
  fi
}

# Function to (re)connect via WiFi
connect_wireless() {
  PHONE_IP="$1"
  SCRCPY_OPTIONS="$2"

  adb tcpip 5555
  sleep 1  # slight delay

  CONNECT_OUTPUT=$(adb connect "$PHONE_IP:5555" 2>&1)

  echo "$CONNECT_OUTPUT"

  if echo "$CONNECT_OUTPUT" | grep -q "ERROR: Server connection failed"; then
    echo "❌ ERROR: Server connection failed. Restarting adb server and retrying..."

    restart_adb_server

    # Retry
    adb tcpip 5555
    sleep 1
    adb connect "$PHONE_IP:5555"
  fi
  scrcpy $SCRCPY_OPTIONS
}

# Main script
if [ $# -lt 1 ]; then
  echo "Usage: $0 usb|<phone_ip_address> [scrcpy_options]"
  echo "Examples:"
  echo "  $0 usb --no-audio"
  echo "  $0 192.168.1.101 --no-audio --max-size 800"
  exit 1
fi

# Check adb server
check_adb_server

# First argument
MODE="$1"
shift

# Remaining arguments
SCRCPY_OPTIONS="$@"

if [ "$MODE" = "usb" ]; then
  echo "📱 Connecting via USB..."
  connect_usb "$SCRCPY_OPTIONS"
else
  echo "📶 Connecting to $MODE wirelessly..."
  connect_wireless "$MODE" "$SCRCPY_OPTIONS"
fi
