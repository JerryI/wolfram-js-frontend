# WLJS container
## Description
This repository provides a container for the [Wolfram JS Frontend](https://github.com/JerryI/wolfram-js-frontend) project. The image is based on the on the [Wolfram Engine](https://hub.docker.com/r/wolframresearch/wolframengine) docker image to provide wolframscript.

I have only so far tested on podman and it is far from perfect. Navigating the directory sometimes causes issues, where it is jumping to the application directory.

## Requirements

To use the image please notice these requirements:

- The mathpass needs to be available at `/Licensing/mathpass` inside the container. Sufficient on first start of the container. Either a bind mount or volume can be used.
- The root directory of WLJS is `/workspace` inside the container. It is possible to mount external storage there to persist the workspace.
- The container further allows specifying the `PUID` and `PGID` environment variables to set the user id and group id of the user accessing the `/workspace` directory. Both default to 1000.
- The WLJS server is started on the following ports: http 4000 (Main http port); ws 4001 (Websocket port); ws2 4002 (Alternate websocket port); docs 4003 (Documentation). 

Example start of the container:

``` podman run -v WolframLicensing:/Licensing -v ~/Documents/wljs:/workspace -e PUID=2000 -e PGID=2000 -p 4000:4000 -p 4001:4001 -p 4002:4002 -p 4003:4003 --name wljs <name of the image> ```

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
