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


# Check if SuiteCRM is already installed
# if [ ! -f /var/www/html/public/legacy/config.php ]; then

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
else
  echo "✅ Existing config.php found — skipping installation."
fi

if [ -f "$CONFIG_FILE" ]; then
  echo "💾 Ensuring config.php is persisted in volume..."
  mkdir -p /var/www/html/public/legacy/test/
  cp -u "$CONFIG_FILE" /var/www/html/public/legacy/test/config.php
  echo "✅ config.php is up to date."
fi

chown -R www-data:www-data .

# # Start Apache in the foreground
echo "🚀 Starting Apache..."
exec "$@"
############################################

