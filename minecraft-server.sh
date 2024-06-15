#!/bin/bash

# Update package index + install required java version
sudo apt-get update > /dev/null
sudo apt-get install openjdk-21-jre-headless -y > /dev/null
echo "Successfully installed Java 21"

# Install screen to keep server active when terminal is closed
sudo apt-get install screen -y > dev/null
echo "Successfully installed screen"

# Install jq to allow parsing of json data
sudo apt-get jq -y > dev/null

# Open up relevant minecraft ports
sudo ufw allow 25565