# Stop the containers and remove them from Docker.
docker stop nginxproxymanager && docker rm nginxproxymanager
docker stop postgres && docker rm postgres
docker stop redis && docker rm redis
docker stop nextcloud && docker rm nextcloud

# Download the latest Docker images.
docker pull jc21/nginx-proxy-manager:latest
docker pull postgres:latest
docker pull redis:latest
docker pull nextcloud:latest

# TEMPORARY WORKAROUND: https://github.com/nextcloud/docker/issues/2283
docker pull nextcloud:29.0.4

# Read path for persistent storage from command line arguments.
VOLUME_PATH=${1}

# Create persistent storage directories for the container volumes.
mkdir -p ${VOLUME_PATH}/nginx
mkdir -p ${VOLUME_PATH}/nginx/data
mkdir -p ${VOLUME_PATH}/nginx/letsencrypt
mkdir -p ${VOLUME_PATH}/postgres
mkdir -p ${VOLUME_PATH}/nextcloud

# Generate passwords for PostgreSQL and Redis.
POSTGRES_PASSWORD=$(openssl rand -base64 32 | tr -dc _A-Z-a-z-0-9)
REDIS_HOST_PASSWORD=$(openssl rand -base64 32 | tr -dc _A-Z-a-z-0-9)

# Create a new Docker bridge network for communication between containers.
docker network inspect nginxproxymanager-nextcloud-postgres-redis >/dev/null 2>&1 || \
    docker network create --driver bridge nginxproxymanager-nextcloud-postgres-redis

# Run the Docker container for Nginx Proxy Manager.
docker run -d \
    --name nginxproxymanager \
    --hostname nginxproxymanager \
    --restart=unless-stopped \
    --network nginxproxymanager-nextcloud-postgres-redis \
    -p 80:80 \
    -p 81:81 \
    -p 443:443 \
    -v "${VOLUME_PATH}/nginx/data:/data" \
    -v "${VOLUME_PATH}/nginx/letsencrypt:/etc/letsencrypt" \
    jc21/nginx-proxy-manager

# Run the Docker container for PostgreSQL.
docker run -d \
    --name postgres \
    --hostname postgres \
    --restart=unless-stopped \
    --network nginxproxymanager-nextcloud-postgres-redis \
    -v "${VOLUME_PATH}/postgres:/var/lib/postgresql/data" \
    -e POSTGRES_DB=nextcloud_db \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
    postgres

# Run the Docker container for Redis.
docker run -d \
    --name redis \
    --hostname redis \
    --restart=unless-stopped \
    --network nginxproxymanager-nextcloud-postgres-redis \
    redis redis-server --requirepass ${REDIS_HOST_PASSWORD}

# Run the Docker container for Nextcloud.
docker run -d \
    --name nextcloud \
    --hostname nextcloud \
    --restart=unless-stopped \
    --network nginxproxymanager-nextcloud-postgres-redis \
    -v "${VOLUME_PATH}/nextcloud:/var/www/html" \
    -e POSTGRES_HOST=postgres \
    -e POSTGRES_DB=nextcloud_db \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
    -e REDIS_HOST=redis \
    -e REDIS_HOST_PASSWORD=${REDIS_HOST_PASSWORD} \
    nextcloud:29.0.4
