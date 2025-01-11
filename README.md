# Edit conf.yaml
- `nano conf.yaml`

# Build the container
- `./build.sh && ./run.sh`

# Run entrypoint.sh in the cointainer
- `docker exec -d ./entrypoint.sh`

## Verify operation via Steam
- `curl -s https://api.steampowered.com/ISteamApps/GetServersAtAddress/v0001?addr=<IP_ADDR> | grep -o 'EGS'`
- EGS indicates Steam can see the server. A blank response means it cannot.

## Access the telnet console
- SSH into the container with `ssh user@<IP_ADDR> 30004`
- Run `./tel.sh`
