# SuiteCRM Docker Image (PHP 8.1 & Apache)

This repository provides a Dockerfile for setting up a SuiteCRM environment using PHP 8.1 and Apache, based on SuiteCRM version 8.6.0.

## Prerequisites

- Download the SuiteCRM 8.6.0 source code (.zip) from the [official SuiteCRM repository](https://suitecrm.com/download/).
- Place the downloaded `.zip` file in the same directory as this Dockerfile.

## Setup Instructions

1. **Unzip the SuiteCRM source code:**
    - Extract the contents of the `.zip` file.
    - Rename the extracted folder to `SuiteCRM`.

1.1 **Implement the database and admin credentials in the .env file:**
    -open the SuiteCRM folder, (the one you just unzipped) and add the following lines to it:
    ```
        SUITECRM_USERNAME=${SUITECRM_USERNAME}
        SUITECRM_PASSWORD=${SUITECRM_PASSWORD}
        DB_USERNAME=${SUITECRM_DATABASE_USER}
        DB_PASSWORD=${SUITECRM_DATABASE_PASSWORD}
        DB_NAME=${SUITECRM_DATABASE_NAME}
    ```

2. **Build the Docker image:**
    ```sh
    docker build -t admwinther/suitecrm:8.6.0 .
    ```

## Notes

- This setup uses PHP 8.1 and Apache as the web server.
- Ensure all files are in the correct directory before building the image.

---


3. **Implement Env. variables:**
The config variables of SuiteCRM are stored in file : /var/www/html/public/legacy/config.php
So, the first thing is to have a dummy config.php file but with the correct credentials in /var/www/html/public/legacy BUT, SuiteCRM make IDs for many components, for example all of the email templates have an ID that are generated at the time of creating the tables!
First we need composer in suiteCRM image. so we need to execute:


4. **Push the Docker image to Docker Hub:**
    ```sh
    docker push admwinther/suitecrm:8.6.0
    ```
   

5. **Run the Docker container:**
    ```sh
    docker run -d -p 8080:80 --name suitecrm admwinther/suitecrm:8.6.0
    ```
   To make your container persistent, you can mount a volume for SuiteCRM config file in:
    ```/var/www/html/your_config_file_here```
if you do not have any config file yet, the container will create one for you at the first run and you just need to keep mounting the same folder in future runs.
