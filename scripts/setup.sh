#!/bin/bash

# setup.sh: Sets up Docker containers and downloads WordPress core automatically.
#
# WARNING: Make sure any persistent data is backed up if needed because
# this script may overwrite or modify files in your wp-app directory.
#
# Usage:
#   chmod +x scripts/setup.sh
#   ./scripts/setup.sh

# Make teardown script executable
chmod +x scripts/teardown.sh

# Start Docker containers
echo "Starting Docker containers..."
docker-compose up -d

echo "Waiting for the database to be ready..."
sleep 15

# Create wp-app directory with proper permissions if it doesn't exist
echo "Creating wp-app directory..."
mkdir -p wp-app
sudo chown -R www-data:www-data wp-app  # Set ownership to www-data

# Check if WordPress is already installed
if [ ! -f wp-app/wp-load.php ]; then
    echo "Downloading WordPress core files..."
    docker-compose run --rm wpcli wp core download --path=/var/www/html --allow-root
else
    echo "WordPress core files already present, skipping download..."
fi

# Create mu-plugins directory and copy our custom plugin using wpcli container
echo "Setting up custom mu-plugins..."
docker-compose run --rm wpcli /bin/sh -c "
    mkdir -p /var/www/html/wp-content/mu-plugins && \
    cp /var/www/config/mu-plugins/wp-smtp-mailhog-setup.php /var/www/html/wp-content/mu-plugins/ && \
    chown -R www-data:www-data /var/www/html/wp-content/mu-plugins
"

echo "Setup complete. WordPress core files and custom plugins are now available." 
