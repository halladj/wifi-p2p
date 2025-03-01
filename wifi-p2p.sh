#!/bin/bash

INTERFACE="wlan0"

# Start wpa_supplicant in background
# sudo wpa_supplicant -Dnl80211 -i $INTERFACE -c /dev/null -B

### TODO: add the wps_pbc thingy
#wpa_cli -i p2p-dev-wlan0 wps_pbc

# Wait for initialization
sleep 2


# Loop to continuously scan and connect
while true; do
    wpa_cli -i p2p-dev-wlan0 wps_pbc

    echo "Scanning for peers..."
    wpa_cli -i p2p-dev-wlan0 p2p_find
    sleep 5  # Give some time to discover devices

    PEERS=$(wpa_cli  -i p2p-dev-wlan0 p2p_peers)
    if [ -n "$PEERS" ]; then
        echo "Found peers: $PEERS"
        for PEER in $PEERS; do
            echo "Trying to connect to $PEER..."
            wpa_cli  -i p2p-dev-wlan0 p2p_connect $PEER pbc persistent
        done
    else
        echo "No peers found. Scanning again..."
    fi

    sleep 10  # Wait before next scan
    wpa_cli -i p2p-dev-wlan0 p2p_stop_find
done

