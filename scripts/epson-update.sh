#!/bin/sh

set -e

PRINTER_IP="$1"
FIRMWARE_FILE="$2"

if [ -z "$PRINTER_IP" ] || [ -z "$FIRMWARE_FILE" ]; then
    echo "Usage: ./epson-update.sh <printer ip> <firmware>"
    echo ""
    echo "NOTE: The firmware file has to be extracted from the *.efu archive."
    exit 1
fi

TMP_DIR="$(mktemp -d)"

temp_cleanup() {
    echo "Cleaning up..."
    if [ -d "$TMP_DIR" ]; then
      rm -rf "$TMP_DIR"
    fi
}

trap 'temp_cleanup' EXIT

echo "Printer IP: $PRINTER_IP"
echo "Firmware:   $FIRMWARE_FILE"
echo "Workdir:    $TMP_DIR"

cd "$TMP_DIR" || exit 3
mv "$FIRMWARE_FILE" "$TMP_DIR/firmware"
FIRMWARE_FILE="$TMP_DIR/firmware"

echo "Notifying printer of upcoming update..."
if ! curl -X GET -f "http://$PRINTER_IP/FIRMWAREUPDATE"; then
    echo "Printer is not ready for firmware updates."
    exit 2
fi

echo "Splitting binary... *chop chop chop*"

# The firmware file contains a header that is not sent to the printer.
# We need to split the firmware...
csplit firmware "/\f/" '{0}'
# And remove the 0x0C Page Feed character itself...
tail -c +2 ./xx01 > firmware
rm ./xx01

echo "Uploading firmware..."

curl -vvvX POST -H "Content-Type: multipart/form-data" -f -F "fname=@./firmware" "http://$PRINTER_IP/DOWN/FIRMWAREUPDATE/ROM1"

exit $?
