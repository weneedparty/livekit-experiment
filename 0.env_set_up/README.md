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


## Generate livekit configuration
> https://docs.livekit.io/oss/deployment/vm/#deploy-to-a-vm

```bash
docker run --rm -it -v $PWD/livekit_config:/output livekit/generate
```

```bash
cd ~/livekit_config/livekit-test.ai-tools.online.xyz

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
API Key: APIW5m6Et9G3M5f
API Secret: pRpGBWvV9HLqiscETSe3vWwNcff4eaMuAAEHxHlG1seC

Here's a test token generated with your keys: 
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MDcyNzc0MzIsImlzcyI6IkFQSVc1bTZFdDlHM001ZiIsImp0aSI6InRvbnlfc3RhcmsiLCJuYW1lIjoiVG9ueSBTdGFyayIsIm5iZiI6MTY3MTI3NzQzMiwic3ViIjoidG9ueV9zdGFyayIsInZpZGVvIjp7InJvb20iOiJzdGFyay10b3dlciIsInJvb21Kb2luIjp0cnVlfX0.zgwgI1Omj6v1gWozGaz0foLr4J3K2AG4b0L4yo7PN4o

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
