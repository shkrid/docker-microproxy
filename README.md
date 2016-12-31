## About
Dockerized lightweight non-caching HTTP(S) proxy server
https://github.com/thekvs/microproxy

## Usage

- default login:pass - microproxy:microproxy
```
docker run -d --name http-proxy -p 3128:3128 shkrid/docker-microproxy
```

- Setup login:pass
```
docker run -d --name http-proxy -p 3128:3128 -e MP_USER=login -e MP_PASS=pass shkrid/docker-microproxy
```

- Custom config:

1. Copy config from running container
 
 ```
docker cp http-proxy:/mp .
 ```
2. Edit configs
 ```
$ cat mp/microproxy.json
{
    "listen": "0.0.0.0:3128",
    "access_log": "/dev/stdout",
    "activity_log": "/dev/stderr",
    "allowed_connect_ports": [443, 80],
    "auth_file": "auth.txt",
    "auth_type": "basic",
    "forwarded_for_header": "delete",
    "via_header": "delete",
    "allowed_networks": ["0.0.0.0/0"]
}

$ cat mp/auth.txt
microproxy:microproxy
 ```
3. Remove old container
 
 ```
$ docker rm -f http-proxy
 ```
4. Start new container with volume mount 
 
 ```
docker run -d --name http-proxy -p 3128:3128 -v $PWD/mp:/mp shkrid/docker-microproxy
 ```
