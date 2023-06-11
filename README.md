# empyrion-server
**Docker image for the [Empyrion](https://empyriongame.com/) dedicated server using WINE**

The image itself contains WINE and steamcmd, along with an entrypoint.sh script that bootstraps the Empyrion dedicated server install via steamcmd.

When running the image, mount the volume /home/user/Steam, to persist the Empyrion install and avoid downloading it on each container start.
Sample invocation:
```
cd empyrion-docker
docker build -t empyrion-dedicated-server .
mkdir -p gamedir
docker run -di -p 30000:30000/udp --restart unless-stopped -v $PWD/gamedir:/home/user/Steam empyrion-dedicated-server

# for experimental version:
cd empyrion-docker
docker build -t empyrion-dedicated-server .
mkdir -p gamedir_beta
docker run -di -p 30000:30000/udp --restart unless-stopped -v $PWD/gamedir_beta:/home/user/Steam -e BETA=1 empyrion-dedicated-server
```

After starting the server, you can edit the dedicated.yaml file at 'gamedir/steamapps/common/Empyrion - Dedicated Server/dedicated.yaml'.
You'll need to restart the docker container after editing.

The DedicatedServer folder has been symlinked to /server, so that you can refer to saves with z:/server/Saves (for instance the save called The\_Game):
```
# cp -r /..../Saves/Games/The_Game 'gamedir/steamapps/common/Empyrion - Dedicated Server/Saves/Games/'
# you might want a symlink for games: ln -s 'gamedir/steamapps/common/Empyrion - Dedicated Server/Saves/Games'
docker run -di -p 30000:30000/udp --restart unless-stopped -v $PWD/gamedir:/home/user/Steam bitr/empyrion-server -dedicated 'z:/server/Saves/Games/The_Game/dedicated.yaml'
```

To append arguments to the steamcmd command, use `-e "STEAMCMD=..."`. Example: `-e "STEAMCMD=+runscript /home/user/Steam/addmods.txt"`.

For more information about the dedicated server itself, refer to the [wiki](https://empyrion.gamepedia.com/Dedicated_Server_Setup).
