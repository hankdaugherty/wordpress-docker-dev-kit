#!/bin/bash

# setup.sh: Sets up Docker containers and downloads WordPress core automatically.
#
# WARNING: Make sure any persistent data is backed up if needed because
# this script may overwrite or modify files in your wp-app directory.
#
# IMPORTANT: Before running this script, review and edit env.example if you want to:
# - Change the WordPress admin email (default: your.email@example.com)
# - Change the WordPress admin username (default: admin)
# These values will be copied to .env during setup.
#
# Usage:
#   1. Review and edit env.example if needed
#   2. Make script executable: chmod +x scripts/setup.sh
#   3. Run script: ./scripts/setup.sh

set -e

# Change to project root directory
cd "$(dirname "$0")"/.. || exit 1

#
# Function Definitions
#
mysql_execute() {
    docker compose exec -T db mysql --protocol=tcp -h"127.0.0.1" -uroot -p"$MYSQL_ROOT_PASSWORD" "$@" 2>/dev/null
}

check_db_connection() {
    docker compose exec -T db mysqladmin --protocol=tcp -h"127.0.0.1" ping -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD"
}

#
# Environment Setup
#
# Check for .env file
if [ ! -f .env ]; then
    echo "No .env file found. Creating one from env.example..."
    if [ ! -f env.example ]; then
        echo "Error: env.example file not found!"
        exit 1
    fi
    
    # Generate random passwords without special characters
    ADMIN_PASSWORD=$(openssl rand -base64 12 | tr -d '/+=' | cut -c1-16)
    ROOT_PASSWORD=$(openssl rand -base64 12 | tr -d '/+=' | cut -c1-16)
    
    # Create new .env file and update ONLY passwords
    cp env.example .env
    sed -i.bak \
        -e "s|MYSQL_ROOT_PASSWORD=.*|MYSQL_ROOT_PASSWORD=$ROOT_PASSWORD|" \
        -e "s|WORDPRESS_DB_PASSWORD=.*|WORDPRESS_DB_PASSWORD=$ROOT_PASSWORD|" \
        -e "s|WORDPRESS_ADMIN_PASSWORD=.*|WORDPRESS_ADMIN_PASSWORD=$ADMIN_PASSWORD|" \
        .env
    rm -f .env.bak
    
    echo "Created .env file with secure random passwords"
fi

# Load environment variables (excluding UID/GID)
set -a
grep -vE '^(#|UID|GID)' .env > .env.tmp && source .env.tmp && rm .env.tmp
set +a

#
# Docker Setup
#
echo "Creating required directories..."
mkdir -p wp-app wp-data

echo "Starting Docker containers..."
docker compose down -v >/dev/null 2>&1 || true
docker compose up -d

#
# Database Setup
#
echo "Waiting for the database to be ready..."
for i in {1..30}; do
    if check_db_connection &>/dev/null; then
        echo "Database service is responsive!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "Error: Database failed to start after 60 seconds"
        exit 1
    fi
    echo "Waiting for database connection... ($i/30)"
    sleep 2
done

echo "Configuring database schema..."
mysql_execute <<-EOSQL
    CREATE DATABASE IF NOT EXISTS $DB_NAME;
    GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$WORDPRESS_DB_USER'@'%';
    FLUSH PRIVILEGES;
EOSQL

#
# WordPress Setup
#
echo "Waiting for WordPress installation to complete..."
timeout 300 bash -c 'until docker compose logs wpcli 2>&1 | grep -q "Success: Installed 8 of 8 plugins"; do sleep 5; done'

#
# Setup Complete
#
echo "Setup complete! Your WordPress site should be available at:"
echo "- WordPress: http://localhost:8000"
echo "- PHPMyAdmin: http://localhost:8080"
echo "- MailHog: http://localhost:8025"
echo
echo "WordPress Admin Credentials:"
echo "- Username: $WORDPRESS_ADMIN_USER"
echo "- Password: $WORDPRESS_ADMIN_PASSWORD"
echo "- Email: $WORDPRESS_ADMIN_EMAIL"
