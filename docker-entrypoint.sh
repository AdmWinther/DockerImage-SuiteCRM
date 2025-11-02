#!/bin/bash
set -e

# # Install Composer
cd /var/www/html/public/legacy
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"

# # Install Composer dependencies for SuiteCRM
cd /var/www/html/public/legacy \
    && composer install --no-dev --optimize-autoloader



############################################


# Print a message for logs
echo "🔧 Starting SuiteCRM container..."

mkdir -p /var/www/html/just_a_test

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

# # Start Apache in the foreground
exec "$@"
############################################
