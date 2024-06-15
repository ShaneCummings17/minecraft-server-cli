# minecraft-server-cli
This CLI is meant to be used for easy creation and administration of vanilla Minecraft servers in a Linux environment.

The CLI can download the appropriate server jar for any version of Minecraft and run a server with just one command.

### Prerequisites
- Port Forwarding for UDP and TCP for desired server port ranges.
- Inbound Firewall rules for UDP and TCP for desired server port ranges.

### Commands
```
minecraft-server initialize    # Download the required packages for the CLI
```
```
minecraft-server create-server [NAME]
    flags:
        -v          The Minecraft version to use (default latest release).
```
```
minecraft-server start-server [NAME]
```
```
minecraft-server delete-server [NAME]
    flags:
        -y          Avoids manual confirmation when deleting a server.
```