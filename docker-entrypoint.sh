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
    echo "Database Host: ${DB_HOST:-ghghghgh}"

    # Install SuiteCRM using CLI-Installer
    # && ./bin/console suitecrm:app:install -u "admin_username" -p "admin_password" -U "db_user" -P "db_password" -H "db_host" -N "db_name" -S "site_url" -d "demo_data" \
    # RUN ./bin/console suitecrm:app:install -u "admin_username" -p "admin_password" -U "root" -P "root" -H "mariadb" -N "new_db" -S "site_url" -d "demo_data"

     # Run the installer with environment variables
     cd /var/www/html

     php bin/console suitecrm:app:install \
       --db_username "root" \
       --db_password "root" \
       --db_host "mariadb" \
       --db_port "3306" \
       --db_name "crm_db" \
       --site_username "admin" \
       --site_password "admin" \
       --site_host "http://localhost" \
       --demoData "no"

     echo "✅ SuiteCRM installation complete."
 else
     echo "✅ SuiteCRM already installed. Skipping setup."
 fi

# # Start Apache in the foreground
exec "$@"
############################################
