#!/bin/bash
set -e


# We do not need it. we will do it in the Dockerfile
# No need to install Composer in the root. Only in /var/www/html/public/legacy if you need to use API or add custom modules.
#We could move the DOWNLOAD part to the Dockerfile but it causes a glitch. We then would need to restart the container to have it working.
#Therefore we keep it here for now.
# We need to install Composer to use API endpoints.
#cd /var/www/html/public/legacy
#php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
#php composer-setup.php --install-dir=/usr/local/bin --filename=composer
#php -r "unlink('composer-setup.php');"
#
### # Install Composer dependencies for SuiteCRM
#cd /var/www/html/public/legacy \
#    && composer install --no-dev --optimize-autoloader --classmap-authoritative

# Wait for the database (optional but helpful)
until nc -z ${DB_HOST:-mariadb} ${DB_PORT:-3306}; do
  echo "⏳ Waiting for database at ${DB_HOST:-mariadb}:${DB_PORT:-3306}..."
  sleep 5
done

# Print a message for logs
echo "🔧 Starting SuiteCRM container..."

#Check if user has loaded a config.php file into /var/www/html/config, if it is there, copy it to the right location
if [ -f "/var/www/html/your_config_file_here/config.php" ]; then
  echo "📁 Found user-provided config.php in /var/www/html/your_config_file_here/ — copying to SuiteCRM directory..."
  cp -u /var/www/html/your_config_file_here/config.php /var/www/html/public/legacy/config.php
  echo "✅ config.php copied successfully."
fi

CONFIG_FILE="/var/www/html/public/legacy/config.php"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "⚙️  No existing config.php found — running SuiteCRM installation..."
  echo "🧩 Running SuiteCRM installer..."
  cd /var/www/html

   php bin/console suitecrm:app:install \
     --db_username "${DB_USERNAME}" \
     --db_password "${DB_PASSWORD}" \
     --db_host "${DB_HOST}" \
     --db_port "${DB_PORT}" \
     --db_name "${DB_NAME}" \
     --site_username "${ADMIN_USERNAME}" \
     --site_password "${ADMIN_PASSWORD}" \
     --site_host "${SITE_URL}" \
     --demoData "no"

  echo "✅ SuiteCRM installation complete."
  # Copy the generated config.php to the persistent location
  echo "💾 Saving generated config.php to persistent volume..."
  cp "$CONFIG_FILE" /var/www/html/your_config_file_here/config.php
  echo "✅ config.php saved successfully."
else
  echo "✅ Existing config.php found — skipping installation."
fi

chown -R www-data:www-data .

# # Start Apache in the foreground
echo "🚀 Starting Apache..."
exec "$@"
############################################

