# Build the image
- `./build.sh [--ssh | -s] [--conf | -c] [--help | -h]`
- `--ssh` will build the image with openssh-server and a small script to run it /home/user/.ssh/sshd.sh
- `--conf` will build the image with support for a custom config file /home/user/conf.yaml
 - conf.yaml may be edited before build or after and then pushed into the container with `docker cp conf.yaml <CONTAINER>:/home/user`
- `--help` will display a short help text and exit
- `build.sh` will also discharge dockerfile.db, entrypoint.sh, and run.sh
 - dockerfile.db is used to build the image, and entrypoint.sh is for internal use in the container.

# Run the container
- run.sh is a viable example of a run script
- By default Empyrion listens on 30000-30004/tcp and 30000-30004/udp
- 30004/tcp is the default port for an unencrypted telnet connection; exposing it could invite a security event.

# Invoke sshd (optional)
- sshinit.sh is a viable example of an sshd invocation.
- It will attempt to run sshd and generate ssh keys and certs.
- It will attempt to exfiltrate the user private key and signed public key from the container
- It will attempt to delete the user private key in the container.

#Additional ssh security
- empyrion:/home/user/.ssh/user.pub may be overwritten for additional security with the following
```
ssh-keygen -t ecdsa -N '' -f user
docker cp user.pub empyrion:/home/user/.ssh/
docker exec -t empyrion ssh-keygen -s .ssh/ca -I 'user' -n user .ssh/user.pub
docker cp empyrion:/home/user/.ssh/user-cert.pub .
```
- Keep ./user and ./user-cert.pub
- If empyrion:/home/user/.ssh/user exists, you should delete it. `docker exec -t empyrion rm .ssh/user`

# Run entrypoint.sh in the container
- `docker exec -d <CONTAINER> ./entrypoint.sh`

# Verify operation via Steam
- `curl -s https://api.steampowered.com/ISteamApps/GetServersAtAddress/v0001?addr=<IP_ADDR> | grep -o 'EGS'`
- EGS indicates Steam can touch the server. A blank response means it cannot.

# Access the telnet console
- Get an internal shell
  - Ssh into the container with `ssh -i user -p 30004 user@<IP_ADDR>`
  - Invoke bash directly with `docker exec -ti <CONTAINER> bash`
- Run `./tel.sh`
