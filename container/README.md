# Wolfram JS Frontend container
## Description
A docker container for the [Wolfram JS Frontend](https://github.com/JerryI/wolfram-js-frontend) project is provided here. The image is based on the on the [Wolfram Engine](https://hub.docker.com/r/wolframresearch/wolframengine) docker image to provide wolframscript.

## Getting Started

1. Make sure you have either installed [docker](https://docs.docker.com/engine/install/) or [podman](https://podman.io/get-started) on your machine.
2. Register at the [Wolfram Engine download page](https://www.wolfram.com/engine/). Click to download (only needed to be redirected to the right place) and then follow the `Get your license` instructions. Register on the next page and acquire the license (it is free). A confirmation message will be sent to your email address. Please follow the link received by email.
3. Start the container:

        docker run -it -v WolframLicensing:/Licensing -v ~/Documents/wljs:/workspace -e PUID=$(id -u) -e PGID=$(id -g) -p 4000:4000 -p 4001:4001 -p 4002:4002 -p 4003:4003 --name wljs ghcr.io/yloose/wolfram-js-frontend:latest

    You will now be prompted for your Wolfram login information, enter it and wait for the message `Open your browser at http://...`. You can now safely detach from the container using <kbd>Ctrl</kbd>+<kbd>p</kbd> <kbd>Ctrl</kbd>+<kbd>q</kbd> and close your terminal.

4. Open a web browser at

        http://127.0.0.1:4000/

## Features

The container is capable of following features:

- An external working directory can be mounted inside the container at `/workspace`.
- The container allows specifying the `PUID` and `PGID` environment variables to set the user id and group id of the user accessing the `/workspace` directory. Both default to 1000.
- A volume or bind mount can be used at `/Licensing` inside the container to persist licensing information.
- The WLJS server is started on the following ports: http 4000 (Main http port); ws 4001 (Websocket port); ws2 4002 (Alternate websocket port); docs 4003 (Documentation). 
- To first activate the container you can either start it in interactive mode like shown in the [Getting Started](#Getting-Started) section or use environment variables.
Use `WOLFRAMID_USERNAME` for the email belonging to the Wolfram Account and `WOLFRAMID_PASSWORD` for the corresponding password. The environment variables only have to be passed on first use.

## NGINX Proxy

The container also includes a nginx proxy running by default. This aggreggates the http and websockets ports into one port at 3000. It also makes it possible to further reverse proxy the application and add TLS encryption as normally the ports and protocols (ws/wss) are hardcoded into the app. To achieve this, nginx rewrites certain parts of the html and javascript during transit.

> **Warning** This is pretty instable and can break at any slight change upstream. The docs also do not work this way.

To use simply expose port 3000 and access the app over there.

### TLS proxy config

To run the container behind a reverse proxy to add TLS support, a minimal nginx configuration similiar to this one could be used:

```
server {
    listen 80;
    server_name wljs.example.com;

    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name wljs.example.com;
    
    ssl_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
    ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;

    set $upstream http://<container_host>:3000;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "keep-alive, upgrade";

        proxy_pass $upstream;
    }
}

```
