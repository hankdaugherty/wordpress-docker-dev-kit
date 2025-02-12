#!/bin/bash

# setup.sh: Sets up Docker containers and downloads WordPress core automatically.
#
# WARNING: Make sure any persistent data is backed up if needed because
# this script may overwrite or modify files in your wp-app directory.
#
# Usage:
#   chmod +x scripts/setup.sh
#   ./scripts/setup.sh

# Check for .env file
if [ ! -f .env ]; then
    echo "Error: .env file not found!"
    echo "Please copy env.example to .env and update the values:"
    echo "cp env.example .env"
    exit 1
fi

# Create necessary directories
echo "Creating required directories..."
mkdir -p neve-child
mkdir -p wp-app
mkdir -p wp-data

# Make teardown script executable
chmod +x scripts/teardown.sh

# Start Docker containers
echo "Starting Docker containers..."
docker-compose up -d

echo "Waiting for the database to be ready..."
sleep 20

# Create mu-plugins directory and copy our custom plugin using wpcli container
echo "Setting up custom mu-plugins..."
docker-compose run --rm wpcli /bin/sh -c "
    mkdir -p /var/www/html/wp-content/mu-plugins && \
    cp /var/www/config/mu-plugins/wp-smtp-mailhog-setup.php /var/www/html/wp-content/mu-plugins/ && \
    chown -R www-data:www-data /var/www/html/wp-content/mu-plugins
"

# Executing WP-CLI to perform WordPress core installation
docker-compose run --rm wpcli /bin/sh -c "
    wp core install --url='http://localhost:8000' --title='WordPress Dev' \
      --admin_user='${WORDPRESS_ADMIN_USER}' --admin_password='${WORDPRESS_ADMIN_PASSWORD}' \
      --admin_email='${WORDPRESS_ADMIN_EMAIL}' --skip-email --allow-root --quiet
"

echo "Setup complete! Your development environment is ready."
echo "WordPress: http://localhost:8000"
echo "phpMyAdmin: http://localhost:8080"
echo "MailHog: http://localhost:8025"
