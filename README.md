# My personal Nextcloud setup
[Nextcloud](https://nextcloud.com/) setup using Docker with [Nginx Proxy Manager](https://nginxproxymanager.com/), [PostgreSQL](https://www.postgresql.org/) and [Redis](https://redis.io/).


**1. Install Docker**

This [Docker installation script](https://github.com/inwerk/docker-debian/) is based on the [installation instructions for Debian-based systems](https://docs.docker.com/engine/install/debian/) from the official Docker documentation. For other platforms, refer to the corresponding instructions from the [Docker documentation](https://docs.docker.com/engine/install/).
```bash
curl -sSL https://raw.githubusercontent.com/inwerk/docker-debian/master/install-docker.sh | sudo bash
```


**2. Install Nextcloud with Nginx Proxy Manager, PostgreSQL and Redis**

Script for installing/updating a Nextcloud Docker image with Nginx Proxy Manager, PostgreSQL and Redis. You can replace `/mnt/data` with your preferred file path.
```bash
curl -sSL https://raw.githubusercontent.com/inwerk/nextcloud-docker/master/install-nextcloud.sh | sudo bash -s -- /mnt/data
```


**3. Configure Nginx Proxy Manager**

Login with the default administrator user:
```
Email:    admin@example.com
Password: changeme
```


Immediately after logging in with this default user you will be asked to modify your details and change your password.

When configuring the Nextcloud proxy host, include this custom Nginx configuration under the `Advanced` tab:
```
client_body_buffer_size 512k;
proxy_read_timeout 86400s;
client_max_body_size 0;


proxy_request_buffering off;


location /.well-known/carddav {
    return 301 $scheme://$host/remote.php/dav;
}

location /.well-known/caldav {
    return 301 $scheme://$host/remote.php/dav;
}
```


**4. Configure Nextcloud**

Script to run after the initial Nextcloud setup (after creating the admin user).
Handles the configuration of various settings, as well as setting up Cron for background jobs.
```bash
curl -sSL https://raw.githubusercontent.com/inwerk/nextcloud-docker/master/setup-nextcloud.sh | sudo bash
```
