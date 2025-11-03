#!/bin/bash
set -e

# No need to install Composer in the root. Only in /var/www/html/public/legacy if you need to use API or add custom modules.
#We could move the DOWNLOAD part to the Dockerfile but it causes a glitch. We then would need to restart the container to have it working.
#Therefore we keep it here for now.
# We need to install Composer to use API endpoints.
cd /var/www/html/public/legacy
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"

## # Install Composer dependencies for SuiteCRM
cd /var/www/html/public/legacy \
    && composer install --no-dev --optimize-autoloader --classmap-authoritative

############################################
#Set the permissions:
#This part in the beginning was in Dockerfile but it did not work.
# So we moved it here.
#echo "🔧 Setting permissions for SuiteCRM..."
#Only the first one is enough for now. If we run the rest it causes  a crash.
#chown -R www-data:www-data /var/www/html
#chmod -R 775 /var/www/html/public/legacy/cache \
#             /var/www/html/public/legacy/custom \
#             /var/www/html/public/legacy/modules \
#             /var/www/html/public/legacy/themes \
#             /var/www/html/public/legacy/data \
#             /var/www/html/public/legacy/upload
#             \
#             /var/www/html/public/legacy/config_override.php    #It does not exist yet at this point.

# Print a message for logs
echo "🔧 Starting SuiteCRM container..."

# Check if SuiteCRM is already installed
 if [ ! -f /var/www/html/public/legacy/config.php ]; then
     echo "🧩 SuiteCRM not installed — running initial setup..."

     # Wait for the database (optional but helpful)
    #  until nc -z ${DB_HOST:-mariadb} ${DB_PORT:-3306}; do
    #      echo "⏳ Waiting for database at ${DB_HOST:-mariadb}:${DB_PORT:-3306}..."
    #      sleep 5
    #  done
# print the environment variable, DB_HOST
    echo "Database Host: ${DB_HOST_ADDRESS:-ghghghgh}"

    # Install SuiteCRM using CLI-Installer
    # && ./bin/console suitecrm:app:install -u "admin_username" -p "admin_password" -U "db_user" -P "db_password" -H "db_host" -N "db_name" -S "site_url" -d "demo_data" \
    # RUN ./bin/console suitecrm:app:install -u "admin_username" -p "admin_password" -U "root" -P "root" -H "mariadb" -N "new_db" -S "site_url" -d "demo_data"

     # Run the installer with environment variables
     cd /var/www/html

     php bin/console suitecrm:app:install \
       --db_username "${DB_USERNAME}" \
       --db_password "${DB_PASSWORD}" \
       --db_host "${DB_HOST_ADDRESS}" \
       --db_port "${DB_PORT}" \
       --db_name "${DB_NAME}" \
       --site_username "${ADMIN_USERNAME}" \
       --site_password "${ADMIN_PASSWORD}" \
       --site_host "${SITE_URL}" \
       --demoData "no"

     echo "✅ SuiteCRM installation complete."
 else
     echo "✅ SuiteCRM already installed. Skipping setup."
 fi

echo "🔧 Setting permissions for SuiteCRM..."
chown -R www-data:www-data /var/www/html

# # Start Apache in the foreground
exec "$@"
############################################
