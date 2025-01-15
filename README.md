# empyrion-server
**Docker image for the [Empyrion](https://empyriongame.com/) dedicated server using WINE**

This Docker image includes WINE and steamcmd, along with an entrypoint script that bootstraps the Empyrion dedicated server installation via steamcmd.

## Breaking changes
The entrypoint no longer `chown`'s the Steam directory, so make sure to run the container as a user with appropriate permissions.

## Usage

### Basic setup
1. Create a directory for your game data:
    ```sh
    mkdir -p gamedir
    ```
2. Run the Docker container:
    ```sh
    docker run -d -p 30000:30000/udp --restart unless-stopped -v $PWD/gamedir:/home/user/Steam bitr/empyrion-server
    ```

### Running the experimental version
1. Create a directory for your beta game data:
    ```sh
    mkdir -p gamedir_beta
    ```
2. Run the Docker container with the `BETA` environment variable set to 1:
    ```sh
    docker run -di -p 30000:30000/udp --restart unless-stopped -v $PWD/gamedir_beta:/home/user/Steam -e BETA=1 bitr/empyrion-server
    ```

## Permission errors
If you're getting permission errors, it's because the folder you mounted in with `-v` didn't already exist and is now created and owned by **root:root**. You need to `chown` the volume mount to **1000:1000** (unless you've specified otherwise when you ran the `docker` command)

## Configuration
After starting the server, you can edit the **dedicated.yaml** file located at **gamedir/steamapps/common/Empyrion - Dedicated Server/dedicated.yaml**. You will need to restart the Docker container after making changes.

The **DedicatedServer** folder is symlinked to **/server**, allowing you to refer to saves with **z:/server/Saves**. For example, for a save called **The_Game**:
```sh
# Run the container with the specific save
docker run -d -p 30000:30000/udp --restart unless-stopped -v $PWD/gamedir:/home/user/Steam bitr/empyrion-server -- -dedicated 'z:/server/Saves/Games/The_Game/dedicated.yaml'
```

## Advanced Usage
To append arguments to the `steamcmd` command, use the `STEAMCMD` environment variable. For example:
```sh
-e "STEAMCMD=+runscript /home/user/Steam/add_scenario.txt"
```

So to add a scenario, you'd add the following to `$PWD/gamedir/add_scenario.txt`:

```
workshop_download_item 383120 <workshop_id>
```

Look for multiplayer scenarios at https://steamcommunity.com/workshop/browse?appid=383120 and use the workshop id (available in the browser url when configuring which scenario to add)

## Additional Information
For more information about setting up the Empyrion dedicated server, refer to the [wiki](https://empyrion.gamepedia.com/Dedicated_Server_Setup).

