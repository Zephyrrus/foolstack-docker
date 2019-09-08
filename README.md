# FoolStack

A full FoolFuuka stack on top of docker to remove the setup overhead and allow portability.

`docker container run -ti --rm --volumes-from foolstack-sphinx --net=container:foolstack-sphinx --name foolstack-sphinx-index manticoresearch/manticore:latest indexer --rotate --all`

```
version: '2'
services:
  foolstack-db:
    image: legsplits/foolstack:percona # because fuck the standard mysql docker configs
    container_name: foolstack-db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: pass
    volumes:
      - foolframe-db:/var/lib/mysql
      - foolframe-db-logs:/var/log/mysql
      - ./sql/db-init.sql:/docker-entrypoint-initdb.d/db-init.sql:ro # IMPORTANT!
  foolstack-php:
    image: legsplits/foolstack:php
    container_name: foolstack-php
    restart: always
    environment:
      - REDIS_ENABLE=true
      - REDIS_PREFIX=foolstack_UwU_          # cancer
      - REDIS_SERVERS='foolstack-redis:6379' # >6379< important
    depends_on:
      - foolstack-db
      - foolstack-redis
    volumes:
      - foolframe-foolframe-temp:/var/www/foolfuuka/public/foolframe/foolz
      - foolframe-foolfuuka-temp:/var/www/foolfuuka/public/foolfuuka/foolz
      - foolframe-foolfuuka-conf:/var/www/foolfuuka/assets/config
      - foolframe-foolframe-conf:/var/www/foolfuuka/app/foolz/foolframe/config
      - foolframe-foolframe-logs:/var/www/foolfuuka/app/foolz/foolframe/logs
#      - foolframe-boards:/var/www/foolfuuka/public/foolfuuka/boards # uncomment for image upload by foolfuuka
  foolstack-nginx:
    image: legsplits/foolstack:nginx
    container_name: foolstack-nginx
#    read_only: true
    restart: always
    depends_on:
      - foolstack-db
      - foolstack-php
      - foolstack-redis
    volumes:
      - foolframe-foolframe-temp:/var/www/foolfuuka/public/foolframe/foolz:ro
      - foolframe-foolfuuka-temp:/var/www/foolfuuka/public/foolfuuka/foolz:ro
      - foolframe-boards:/var/www/foolfuuka/public/foolfuuka/boards:ro
#    tmpfs:
#      - /tmp
    ports:
      - 1346:80
  foolstack-redis:
    container_name: foolstack-redis
    image: healthcheck/redis
    volumes:
      - foolframe-redis:/data
  foolstack-scraper:
    image: legsplits/foolstack:asagi # :asagi :eve :hayden
    container_name: foolstack-scraper
    restart: always
    depends_on:
      - foolstack-db
    environment:
      - UID=1000
      - GID=1000
      - SCRAPER_BOARDS=w,wg
      - SCRAPER_DOWNLOAD_MEDIA=False     # true/false if hayden, True/False if eve
      - SCRAPER_DOWNLOAD_THUMBS=False    # true/false if hayden, True/False if eve
    volumes:
      - foolframe-boards:/boards
  foolstack-sphinx:
    image: manticoresearch/manticore:latest
    container_name: foolstack-sphinx
    restart: always
    depends_on:
      - foolstack-db
    volumes:
    - foolframe-sphinx:/var/lib/manticore  # directory where sphinx will store index data
#    - ./sphinx.conf:/etc/sphinxsearch/sphinx.conf  # SphinxSE configuration file
    mem_limit: 512m # match indexer.value from sphinx.conf
volumes:
  foolframe-foolframe-temp:     # FoolFrame generated content on the fly via php
    driver: local
  foolframe-foolfuuka-temp:     # FoolFooka generated content on the fly via php
    driver: local
  foolframe-foolframe-logs:     # FoolFrame logs
    driver: local
  foolframe-foolfuuka-conf:     # Persistent configs
    driver: local
  foolframe-foolframe-conf:     # Persistent configs
    driver: local
  foolframe-db:                 # Percona DB
    driver: local
  foolframe-db-logs:            # Percona DB Logs
    driver: local
  foolframe-sphinx:             # SphinxDB
    driver: local
  foolframe-boards:             # Downloaded images and thumbs
    driver: local
  foolframe-redis:              # Redis
    driver: local
```