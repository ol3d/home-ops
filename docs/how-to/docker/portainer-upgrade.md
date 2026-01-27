# Upgrading Portainer

This guide provides instructions for upgrading Portainer Community Edition running as
a Docker container. Portainer supports direct upgrades between LTS (Long-Term Support)
versions with automatic database migration and minimal downtime.

## Prerequisites

- Docker access on the host running Portainer
- Backup storage location on the host
- Maintenance window (~2-5 minutes downtime)

## Important Note on HTTPS Access

Portainer listens on **port 9443 for HTTPS** and port 9000 for HTTP. If you were
previously accessing Portainer at `https://your-host:9443`, ensure you include the
`-p 9443:9443` port mapping in your docker run command.

## Pre-Upgrade Backup

**⚠️ CRITICAL:** Always backup Portainer data before upgrading.

1. **Stop Portainer:**

    ```bash
    docker stop portainer
    ```

2. **Backup Data Volume:**

    ```bash
    BACKUP_DIR="/backup/portainer-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    docker run --rm -v portainer_data:/data -v "$BACKUP_DIR":/backup busybox \
      tar czf /backup/portainer-data-backup.tar.gz -C /data .
    ```

3. **Verify Backup:**

    ```bash
    ls -lh "$BACKUP_DIR"
    ```

## Upgrade Procedure

### Standard Docker Method

1. **Stop and Remove Container:**

    ```bash
    docker stop portainer
    docker rm portainer
    ```

2. **Pull New Image:**

    ```bash
    docker pull portainer/portainer-ce:latest
    ```

    Or specify a version:

    ```bash
    docker pull portainer/portainer-ce:2.33.6
    ```

3. **Start New Container:**

    ```bash
    docker run -d --name portainer --restart=always -p 8000:8000 -p 9000:9000 \
      -p 9443:9443 -v portainer_data:/data \
      -v /var/run/docker.sock:/var/run/docker.sock \
      portainer/portainer-ce:latest
    ```

4. **Monitor Startup:**

    ```bash
    docker logs -f portainer
    ```

    Look for `Database migrated successfully` and `Starting Portainer`.

### Docker Compose Method

1. **Update docker-compose.yml:**

    ```yaml
    version: '3.8'

    services:
      portainer:
        image: portainer/portainer-ce:latest
        container_name: portainer
        restart: always
        ports:
          - "8000:8000"
          - "9000:9000"
          - "9443:9443"
        volumes:
          - portainer_data:/data
          - /var/run/docker.sock:/var/run/docker.sock

    volumes:
      portainer_data:
    ```

2. **Pull and Restart:**

    ```bash
    docker-compose pull
    docker-compose up -d
    ```

## Post-Upgrade Verification

- [ ] Access Portainer web UI at `https://your-host:9443` or `http://your-host:9000`
- [ ] Log in and verify version under **Settings > General**
- [ ] Check that containers, images, volumes are visible
- [ ] Test Docker Compose stacks are functional

## Rollback Procedure

If critical issues occur, restore from backup:

1. **Stop and Remove Current Container:**

    ```bash
    docker stop portainer
    docker rm portainer
    docker volume rm portainer_data
    docker volume create portainer_data
    ```

2. **Restore Backup:**

    ```bash
    docker run --rm -v portainer_data:/data -v "$BACKUP_DIR":/backup busybox \
      tar xzf /backup/portainer-data-backup.tar.gz -C /data
    ```

3. **Start Previous Version:**

    ```bash
    docker run -d --name portainer --restart=always -p 8000:8000 -p 9000:9000 \
      -p 9443:9443 -v portainer_data:/data \
      -v /var/run/docker.sock:/var/run/docker.sock \
      portainer/portainer-ce:<previous-version>
    ```

## Additional Resources

- [Portainer Release Notes](https://docs.portainer.io/whats-new)
- [Portainer Official Documentation](https://docs.portainer.io/)
- [Portainer GitHub Issues](https://github.com/portainer/portainer/issues)
