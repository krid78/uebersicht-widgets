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
  echo '    "macaddress":"'$3'",'
  echo '    "ssid":"'$4'"'
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
HWPORTINFO=($(networksetup -listallhardwareports |grep -A2 "${NWDEVICE}"))
AIRPORT=($(networksetup -getairportnetwork "${HWPORTINFO[1]#*: }"))
if [[ $? -eq 0 ]]; then
  exportService "${NWDEVICE}" "${ip#*: }" "${mac#*: }" "${AIRPORT#*: }"
else
  exportService "${NWDEVICE}" "${ip#*: }" "${mac#*: }"
fi
done

# End the JSON
endJSON

# vim: sw=2:ts=2:sts=2
