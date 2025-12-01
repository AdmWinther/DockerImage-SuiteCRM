#!/bin/bash
set -e


# Wait for the database (optional but helpful)
until nc -z ${DB_HOST:-mariadb} ${DB_PORT:-3306}; do
  echo "⏳ Waiting for database at ${DB_HOST:-mariadb}:${DB_PORT:-3306}..."
  sleep 5
done



## Print a message for logs
#echo "🔧 Starting SuiteCRM container..."
#
##Check if user has loaded a config.php file into /var/www/html/config, if it is there, copy it to the right location
#if [ -f "/var/www/html/your_config_file_here/config.php" ]; then
#  echo "📁 Found user-provided config.php in /var/www/html/your_config_file_here/ — copying to SuiteCRM directory..."
#  cp -u /var/www/html/your_config_file_here/config.php /var/www/html/public/legacy/config.php
#  echo "✅ config.php copied successfully."
#  echo "💾 Saving provided cache directory"
#  cp -u /var/www/html/your_cache_directory_here /var/www/html/public/legacy/cache/
#  cp -u /var/www/html/your_cache_directory_here /var/www/html/cache/
#  echo "✅ cache directory copied successfully."
#fi
#
CONFIG_FILE="/var/www/html/public/legacy/config.php"
if [ ! -f "$CONFIG_FILE" ]; then

  echo "No persistent data found for SuiteCRM installation."
  echo "Copying SuiteCRM source files to /var/www/html/..."
  cp -R /home/suitecrm_source/* /var/www/html/
  cp /home/suitecrm_source/.env /var/www/html/.env

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


     echo "🔧 Ensuring correct permissions for SuiteCRM files..."
     cd /var/www/html/
     echo "🔧 Setting ownership to www-data..."
     chown -R www-data:www-data .
      echo "🔧 Setting file permissions..."
     chmod -R 755 .
     echo "✅ Permissions set."
fi
#  echo "✅ SuiteCRM installation complete."
#  # Copy the generated config.php to the persistent location
#  echo "💾 Saving generated config.php to persistent volume..."
#  cp "$CONFIG_FILE" /var/www/html/your_config_file_here/config.php
#  echo "✅ config.php saved successfully."
#  echo "💾 Saving generated content in cache directory to persistent volume..."
#  cp -R /var/www/html/public/legacy/cache/ /var/www/html/your_cache_directory_here
#  cp -R /var/www/html/cache/ /var/www/html/your_cache_directory_here
#  echo "✅ Cache saved successfully."
#else
#  echo "✅ Existing config.php found — skipping installation."
#fi
#

# # Start Apache in the foreground
echo "🚀 Starting Apache..."
exec "$@"
############################################

