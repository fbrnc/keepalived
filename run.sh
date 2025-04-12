#!/bin/bash

# Start Keepalived in the background
echo "Starting Keepalived..."
keepalived --dont-fork --log-console &

# Start Keepalived Exporter in the background
echo "Starting Keepalived Exporter..."
keepalived_exporter &

# Wait for all background processes to finish
wait