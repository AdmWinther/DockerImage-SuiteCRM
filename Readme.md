# SuiteCRM Docker Image (PHP 8.1 & Apache)

This repository provides a Dockerfile for setting up a SuiteCRM environment using PHP 8.1 and Apache, based on SuiteCRM version 8.6.0.

## Prerequisites

- Download the SuiteCRM 8.6.0 source code (.zip) from the [official SuiteCRM repository](https://suitecrm.com/download/).
- Place the downloaded `.zip` file in the same directory as this Dockerfile.

## Setup Instructions

1. **Unzip the SuiteCRM source code:**
    - Extract the contents of the `.zip` file.
    - Rename the extracted folder to `SuiteCRM`.

2. **Build the Docker image:**
    ```sh
    docker build -t suitecrm:8.6.0 .
    ```

## Notes

- This setup uses PHP 8.1 and Apache as the web server.
- Ensure all files are in the correct directory before building the image.

---