#!/bin/bash

############################################
# # Install Composer
# cd /var/www/html/public/legacy
# php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
# php composer-setup.php --install-dir=/usr/local/bin --filename=composer
# php -r "unlink('composer-setup.php');"

# # Install Composer dependencies for SuiteCRM
# RUN cd /var/www/html/public/legacy \
#     && composer install --no-dev --optimize-autoloader


# set -e
############################################


# Print a message for logs
echo "🔧 Starting SuiteCRM container..."

mkdir -p /var/www/html/just_a_test

# Check if SuiteCRM is already installed
############################################
# if [ ! -f /var/www/html/public/legacy/config.php ]; then
#     echo "🧩 SuiteCRM not installed — running initial setup..."

#     # Wait for the database (optional but helpful)
#     until nc -z ${DB_HOST:-mariadb} ${DB_PORT:-3306}; do
#         echo "⏳ Waiting for database at ${DB_HOST:-mariadb}:${DB_PORT:-3306}..."
#         sleep 5
#     done

#     # Run the installer with environment variables
#     ./bin/console suitecrm:app:install \
#       -u "${SUITECRM_USERNAME:-admin}" \
#       -p "${SUITECRM_PASSWORD:-admin}" \
#       -U "${DB_USER:-root}" \
#       -P "${DB_PASSWORD:-root}" \
#       -H "${DB_HOST:-mariadb}" \
#       -N "${DB_NAME:-suitecrm}" \
#       -S "${SITE_URL:-http://localhost}" \
#       -d "${DEMO_DATA:-no}"

#     echo "✅ SuiteCRM installation complete."
# else
#     echo "✅ SuiteCRM already installed. Skipping setup."
# fi

# # Start Apache in the foreground
# exec "$@"
############################################
