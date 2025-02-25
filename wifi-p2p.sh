#!/bin/bash

INTERFACE="wlan0"

# Start wpa_supplicant in background
sudo wpa_supplicant -Dnl80211 -i $INTERFACE -c /dev/null -B

# Wait for initialization
sleep 2

# Start P2P listen mode
sudo wpa_cli p2p_listen

# Loop to continuously scan and connect
while true; do
    echo "Scanning for peers..."
    sudo wpa_cli p2p_find
    sleep 5  # Give some time to discover devices

    PEERS=$(sudo wpa_cli p2p_peers)
    if [ -n "$PEERS" ]; then
        echo "Found peers: $PEERS"
        for PEER in $PEERS; do
            echo "Trying to connect to $PEER..."
            sudo wpa_cli p2p_connect $PEER pbc persistent
        done
    else
        echo "No peers found. Scanning again..."
    fi

    sleep 10  # Wait before next scan
done

