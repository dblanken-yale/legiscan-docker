#!/bin/bash
# Initialize LegiScan configuration

set -e

echo "Initializing LegiScan configuration..."

# Check if config.php exists
if [ ! -f legiscan/config.php ]; then
  echo "Creating config.php from config.dist.php..."
  cp legiscan/config.dist.php legiscan/config.php

  # Update database configuration
  sed -i.bak 's/dsn = "mysql:host=localhost;port=3306;dbname=legiscan_api"/dsn = "mysql:host=db;port=3306;dbname=legiscan_api"/' legiscan/config.php
  sed -i.bak 's/db_pass = /db_pass = legiscan_password/' legiscan/config.php

  # Add API key if provided
  if [ ! -z "$LEGISCAN_API_KEY" ]; then
    sed -i.bak "s/api_key = /api_key = $LEGISCAN_API_KEY/" legiscan/config.php
  fi

  # Remove backup file
  rm -f legiscan/config.php.bak

  echo "Configuration file created successfully!"
else
  echo "config.php already exists. Skipping creation."
fi

echo "Done!"
