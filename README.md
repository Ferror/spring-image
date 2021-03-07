# spring-image

![Docker Hub](https://badgen.net/docker/size/ferror/spring-image/latest)

Makefile
```makefile
run:
    ./gradlew build
    exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
rerun:
    ./gradlew build
    supervisorctl restart spring
```

docker-compose.yml
    
```dockerfile
services:
    traefik:
        image: traefik:2.3
        command:
            - "--log.level=DEBUG"
            - "--api.insecure=true"
            - "--providers.docker=true"
            - "--providers.docker.exposedbydefault=false"
            - "--entrypoints.web.address=:80"
        ports:
            - "80:80"
            - "8080:8080"
        volumes:
            - /var/run/docker.sock:/var/run/docker.sock:ro
        networks:
            ferror:
                ipv4_address: 192.168.10.2

    spring:
        image: ferror/spring-image
        command: ["make", "run"]
        volumes:
            - ./:/app:delegated
        labels:
            - "traefik.enable=true"
            - "traefik.http.routers.spring.rule=Host(`spring.domain.localhost`)"
        networks:
            - ferror

networks:
    ferror:
        name: ferror
        driver: bridge
        ipam:
            driver: default
            config:
                - subnet: 192.168.10.0/24
```
