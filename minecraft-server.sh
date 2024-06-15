#!/bin/bash
function initialize() {
    # Update package index + install required java versions
    sudo apt-get update > /dev/null
    sudo apt-get install openjdk-21-jre-headless -y > /dev/null
    echo "Successfully installed Java 21"

    sudo apt-get install openjdk-17-jre-headless -y > /dev/null
    echo "Successfully installed Java 17"

    sudo apt-get install openjdk-8-jre-headless -y > /dev/null
    echo "Successfully installed Java 8"

    # Install jq to allow parsing of json data
    sudo apt-get install jq -y > /dev/null
    echo "Successfully installed jq"

    # Make servers directory
    mkdir -p ~/servers

}

function create-server() {
    # Get the server name
    if [ -z $1 ]
    then
        echo "You must provide a server name."
        exit 1
    else
        SERVER_NAME=$1;
        mkdir ~/servers/$SERVER_NAME || {
            echo "You already have a server by this name!"
            exit 1
        }
        shift
    fi

    # Get requested server version from user; if does not exist, gets most recent
    while getopts v:n: flag; do
        case $flag in
            v) VERSION="$OPTARG" ;;
            n) SERVER_NAME="$OPTARG";;
            *) exit 1 ;;
        esac
    done

    if [ -z "$VERSION" ]; then
        VERSION=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq .latest.release | tr -d '"')
    fi

    # Get url of specified minecraft version server.jar
    echo "Downloading server.jar for Minecraft version $VERSION"
    VERSION_URL=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq --arg VERSION $VERSION '.versions[] | select(.id | contains($VERSION))? | .url' | head -n 1 | tr -d '"')
    SERVER_URL=$(curl -s $VERSION_URL | jq .downloads.server.url | tr -d '"')
    curl -s $SERVER_URL --create-dirs -o ~/servers/$SERVER_NAME/server.jar

}

function delete-server() {
    # Get the server name
    if [ -z $1 ]
    then
        echo "You must provide a server name."
        exit 1
    else
        SERVER_NAME=$1;
        DIRECTORY=~/servers/$SERVER_NAME
        shift
        if [ ! -d "$DIRECTORY" ]
        then
            echo "This server does not exist!"
            exit 1
        fi
        while getopts y flag; do
            case $flag in
                y) DELETE=true ;;
                *) exit 1 ;;
            esac
        done
    fi

    # Extra layer of protection to protect against accidental deletion
    if [ -z "$DELETE" ]; then
        while true; do
            read -p "Are you sure you want to delete $SERVER_NAME? " yn
            case $yn in
                [Yy]* ) break;;
                [Nn]* ) exit;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    fi

    sudo rm -rf $DIRECTORY
    echo "Server $SERVER_NAME successfully deleted."

}

function start-server() {
    # Get the server name
    if [ -z $1 ]
    then
        echo "You must provide a server name."
        exit 1
    else
        SERVER_NAME=$1;
    fi

    # Start server application
    cd ~/servers/$SERVER_NAME/
    sudo /usr/lib/jvm/java-21-openjdk-amd64/bin/java -Xms1G -Xmx2G -jar server.jar nogui

    # Approve EULA if first time starting the server
    if grep -q "false" eula.txt; then
        sed -i -e 's/false/true/g' eula.txt
        sudo /usr/lib/jvm/java-21-openjdk-amd64/bin/java -Xms1G -Xmx2G -jar server.jar nogui
    fi

}


# function stop_server() {

# }
"$@"
