# Edit conf.yaml
- `nano conf.yaml`

# Build the container
- `./build.sh && ./run.sh`
- run.sh will start the ssh server and pull the user key (./user) and certificate (user-cert.pub)

#Additional security
- empyrion:/home/user/.ssh/user.pub may be overwritten for additional security with the following
```
ssh-keygen -t ecdsa -N '' -f user
docker cp user.pub empyrion:/home/user/.ssh/
docker exec -t empyrion ssh-keygen -s .ssh/ca -I 'user' -n user .ssh/user.pub
docker cp empyrion:/home/user/.ssh/user-cert.pub .
```
- keep ./user and ./user-cert.pub
- if empyrion:/home/user/.ssh/user exists, you should delete it. `docker exec -t empyrion rm .ssh/user`

# Run entrypoint.sh in the cointainer
- `docker exec -d ./entrypoint.sh`

## Verify operation via Steam
- `curl -s https://api.steampowered.com/ISteamApps/GetServersAtAddress/v0001?addr=<IP_ADDR> | grep -o 'EGS'`
- EGS indicates Steam can see the server. A blank response means it cannot.

## Access the telnet console
- SSH into the container with `ssh -i user -p 30004 user@<IP_ADDR>`
- Run `./tel.sh`
