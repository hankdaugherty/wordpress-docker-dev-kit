#!/bin/bash

# Teardown script for stopping Docker containers and completely removing persistent data.
# WARNING: This will permanently remove the 'wp-app' and 'wp-data' directories along with their contents,
# including any WordPress core files, uploaded assets, or database files.
# Be sure to back up any important data beforehand.

# Prompt for confirmation
read -p "This script will stop Docker containers, remove any named Docker volumes, and delete the 'wp-app' and 'wp-data' directories entirely. Continue? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Bring down the Docker containers and remove volumes
echo "Stopping Docker containers and removing volumes..."
docker-compose down -v

# Remove the wp-app and wp-data directories
echo "Removing wp-app and wp-data directories..."
rm -rf wp-app wp-data

echo "Teardown complete." 