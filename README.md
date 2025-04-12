# keepalived Docker container

This is a simple Ubuntu 24.04 based Docker container including keepalived and [gen2brain's keepalived_exporter](https://github.com/gen2brain/keepalived_exporter).

The repo also includes a create-config.sh script to generate keepalived configuration for the master and the backup server based on the provided IP addresses in the .env file.

I use docker image to run [blocky](https://github.com/0xERR0R/blocky) in a HA configuration based on [Pascal Riesinger's blog post](https://riesinger.dev/posts/ha-dns-adblocking-with-blocky/). That's why I also included the simple check_blocky.sh script.

## Example usage:

Make sure check_blocky.sh has the correct permissions:
```bash
chmod 700 check_blocky.sh 
chown root check_blocky.sh
```

```yaml
services:
  keepalived:
    image: ghcr.io/fbrnc/keepalived:v1.0.0
    container_name: keepalived
    restart: always
    network_mode: host
    privileged: true
    volumes:
      - ./keepalived_master.conf:/etc/keepalived/keepalived.conf
      # or: - ./keepalived_backup.conf:/etc/keepalived/keepalived.conf
      - ./check_blocky.sh:/usr/local/bin/check_blocky.sh
```

Prometheus metrics will be expose via http://127.0.0.1:9652/metrics