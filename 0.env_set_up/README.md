# Set up the environment

## Set up docker
```bash
#sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

## Set up docker-compose
```bash
sudo apt install docker-compose
```

## Set up `cloudflare` DNS configuration
### 1. buy a domain
### 2. bind it to `cloudflare`
https://community.cloudflare.com/t/step-1-adding-your-domain-to-cloudflare/64309

### 3. set up two `A record`
![](images/1.setup_two_a_records.png)

For exmple:

livekit-test.ai-tools-online.xyz

livekit-test-turn.ai-tools-online.xyz

livekit-test-grpc-call-service.ai-tools-online.xyz


## Generate livekit configuration
> https://docs.livekit.io/oss/deployment/vm/#deploy-to-a-vm

```bash
docker run --rm -it -v $PWD/livekit_config:/output livekit/generate

cd livekit_config/livekit-test.ai-tools-online.xyz
ls
```

You'll get following files after you run the above command:
```
docker-compose.yaml  
caddy.yaml  
livekit.yaml  
redis.conf

init_script.sh  
caddy_data  
```

> `docker-compose.yaml` is the center for dev. (It will use `livekit.yaml` and `redis.conf`)

> `caddy.yaml` is the center for serving. (It listens 443 port)

> only `caddy.yaml` exposes its service to public, others running under `127.0.0.1`

## Modify caddy to reverse proxy GRPC
```
# vim caddyl4_Dockerfile
FROM golang:1.19-alpine as builder

ARG TARGETOS
ARG TARGETPLATFORM
ARG TARGETARCH
ARG CADDY_VERSION="v2.6.2"
ENV CADDY_VERSION=$CADDY_VERSION
RUN echo building caddy $CADDY_VERSION for "$TARGETOS"

WORKDIR /workspace

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build \
    --with github.com/abiosoft/caddy-yaml \
    --with github.com/mholt/caddy-l4 \
    --with github.com/mholt/caddy-grpc-web

FROM alpine

COPY --from=builder /workspace/caddy /bin/caddy
```

```
# vim docker-compose.yaml
version: "3.9"
services:
  caddy:
    image: livekit/caddyl4
    #build:
    #  context: ./
    #  dockerfile: ./caddyl4_Dockerfile
    command: run --config /etc/caddy.yaml --adapter yaml
    restart: unless-stopped
    network_mode: "host"
    volumes:
      - ./caddy.yaml:/etc/caddy.yaml
      - ./caddy_data:/data
  livekit:
    image: livekit/livekit-server:latest
    command: --config /etc/livekit.yaml
    restart: unless-stopped
    network_mode: "host"
    volumes:
      - ./livekit.yaml:/etc/livekit.yaml
  redis:
    image: redis:6-alpine
    command: redis-server /etc/redis.conf
    network_mode: "host"
    volumes:
      - ./redis.conf:/etc/redis.conf
```

```
# vim caddy.yaml
logging:
  logs:
    default:
      level: INFO
storage:
  module: file_system
  root: /data
apps:
  tls:
    certificates:
      automate:
        - livekit-test.ai-tools-online.xyz
        - livekit-test-turn.ai-tools-online.xyz
        - livekit-test-grpc-call-service.ai-tools-online.xyz
  http:
    servers:
      main_:
        listen:
          - ':443'
        routes:
          - match:
              - host:
                  - livekit-test-grpc-call-service.ai-tools-online.xyz
          - handle:
              - handler: reverse_proxy
                flush_interval: -1
                transport:
                  protocol: http
                  versions:
                    - h2c
                    - '2'
                upstreams:
                  - Dial: localhost:40058
  layer4:
    servers:
      main:
        listen:
          - ':443'
        routes:
          - match:
              - tls:
                  sni:
                    - livekit-test-turn.ai-tools-online.xyz
            handle:
              - handler: tls
              - handler: proxy
                upstreams:
                  - dial:
                      - localhost:5349
          - match:
              - tls:
                  sni:
                    - livekit-test.ai-tools-online.xyz
            handle:
              - handler: tls
                connection_policies:
                  - alpn:
                      - http/1.1
              - handler: proxy
                upstreams:
                  - dial:
                      - localhost:7880

```

> `web-grpc` can get supported by using: https://caddyserver.com/docs/modules/http.handlers.grpc_web

## Run livekit service

```bash
docker-compose up
```

```
Your production config files are generated in directory: livekit-test.ai-tools-online.xyz

Please point DNS for livekit-test.ai-tools-online.xyz and livekit-test-turn.ai-tools-online.xyz to the IP address of your server.
Once started, Caddy will automatically acquire TLS certificates for the domains.

The file "init_script.sh" is a script that can be used in the "user-data" field when starting a new VM.

Please ensure the following ports are accessible on the server
 * 443 - primary HTTPS and TURN/TLS
 * 80 - for TLS issuance
 * 7881 - for WebRTC over TCP
 * 443/UDP - for TURN/UDP
 * 50000-60000/UDP - for WebRTC over UDP

Server URL: wss://livekit-test.ai-tools-online.xyz
API Key: APIVVhGF42WGq9a
API Secret: TxOCYYNl6MIYtfedhaEq7lhyUsNX93DveVi3smZYSciB

Here's a test token generated with your keys: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MDczNzc2NjQsImlzcyI6IkFQSVZWaEdGNDJXR3E5YSIsImp0aSI6InRvbnlfc3RhcmsiLCJuYW1lIjoiVG9ueSBTdGFyayIsIm5iZiI6MTY3MTM3NzY2NCwic3ViIjoidG9ueV9zdGFyayIsInZpZGVvIjp7InJvb20iOiJzdGFyay10b3dlciIsInJvb21Kb2luIjp0cnVlfX0.17qEiI6wEXlLTtwsXW1lAxA18de7qgT14o8xxXbbnw8

An access token identifies the participant as well as the room it's connecting to
```


<!-- ## Install nginx
```bash
apt install nginx -y
```

## Generate SSL keys by using Let's Encrypt

```bash
apt install snapd
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot

certbot certonly --nginx
```

You'll get two files for one url:
```
Certificate is saved at: /etc/letsencrypt/live/livekit-test-turn.ai-tools-online.xyz/fullchain.pem

Key is saved at:         /etc/letsencrypt/live/livekit-test-turn.ai-tools-online.xyz/privkey.pem
```

## Install and config nginx
```bash
apt install nginx -y

cd /etc/nginx

vim nginx.conf
```

```
        server {
            listen 80 default_server;
            return 301 https://$host$request_uri;
        }

        server {
            listen 443 ssl;
            server_name livekit-test.ai-tools.online.xyz;

            ssl_certificate      /etc/letsencrypt/live/bbs.ai-tools-online.xyz/fullchain.pem;
            ssl_certificate_key  /etc/letsencrypt/live/bbs.ai-tools-online.xyz/privkey.pem;

            ssl_session_cache    shared:SSL:1m;
            ssl_session_timeout  5m;

            location / {
                #proxy_pass http://144.202.109.163:8088/;
                proxy_pass http://127.0.0.1:8088/;
                #proxy_set_header Host $http_host;
                #proxy_set_header X-Real-IP $remote_addr;
                #proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                #proxy_set_header X-Forwarded-Proto $scheme;
            }
        }

``` -->
