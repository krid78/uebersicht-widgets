#!/bin/bash

# This function will start our JSON text.
startJSON() {
  echo '{'
  echo '  "service" : ['
}

# This function will return a single block of JSON for a single service.
exportService() {
  echo '  {'
  echo '    "name":"'$1'",'
  echo '    "ipaddress":"'$2'",'
  echo '    "macaddress":"'$3'"'
  if [[ "x" != "x"$4 ]]; then
    echo '    "ssid":"'$4'"'
  fi
  echo '  }'
}

# This function will finish our JSON text.
endJSON() {
  echo '  ]'
  echo '}'
}

# Start the JSON.
startJSON

IFS="
"
for NWDEVICE in \
  "Thunderbolt Ethernet" \
  "," \
  "Wi-Fi"; do
if [[ $NWDEVICE == "," ]]; then
  # Place a comma between services.
  echo '  ,'
  continue
fi
# Output the Ethernet information.
NWSERVICE=($(networksetup -getinfo "${NWDEVICE}"))
ip=${NWSERVICE[1]}
mac=${NWSERVICE[@]: -1:1}
IFS="
 "
DEVICENAME=($(networksetup -listallhardwareports |grep -A2 Wi-Fi))
AIRPORT=($(networksetup -getairportnetwork "${DEVICENAME[4]}"))
if [[ $? -eq 0 ]]; then
  exportService "${NWDEVICE}" "${ip#*: }" "${mac#*: }" "${AIRPORT[3]}"
else
  exportService "${NWDEVICE}" "${ip#*: }" "${mac#*: }"
fi
done

# End the JSON
endJSON

# vim: sw=2:ts=2:sts=2
