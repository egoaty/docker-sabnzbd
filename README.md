# docker-sabnzbd
Small image (alpine based) for SABnzbd download manager

Example docker-compose:

```
version: "2.1"
services:
  sabnzbd:
    image: egoaty/sabnzbd
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - /path/to/config:/config
      - /path/to/downloads/complete:/downloads
      - /path/to/downloads/incomplete:/incomplete-downloads
      - /path/to/downloads/nzb:/nzb
    ports:
      - 8080:8080
      - 9090:9090
    restart: unless-stopped
```

