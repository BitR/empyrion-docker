# Build the container
- `./build.sh && ./run.sh`

# Edit conf.yaml
- `nano conf.yaml`
- `docker cp conf.yaml empyrion:/home/user/`

# Run entrypoint.sh in the cointainer
- `docker exec -d ./entrypoint.sh`

## Access the telnet console
- SSH into the container with `ssh <IP_ADDR> 30004`
- Run `./tel.sh`
