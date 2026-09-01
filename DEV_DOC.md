# Developer Documentation

## Prerequisites

Install the following software:

- Docker
- Docker Compose
- GNU Make

---

# Project structure

```text
.
├── Makefile
├── srcs
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements
│       ├── mariadb
│       ├── nginx
│       └── wordpress
```

Each service contains its own Dockerfile and configuration files.

---

# Environment configuration

Create the file:

```text
srcs/.env
```

Example:

```env
DOMAIN_NAME=login.42.fr

MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=password
MYSQL_ROOT_PASSWORD=rootpassword

WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=adminpassword
WP_ADMIN_EMAIL=admin@example.com

WP_USER=user
WP_USER_PASSWORD=userpassword
WP_USER_EMAIL=user@example.com
```

This file is read by Docker Compose during startup.

---

# Build and launch

Using the Makefile:

```bash
make
```

Equivalent Docker Compose command:

```bash
docker compose -f srcs/docker-compose.yml up --build
```

Rebuild after modifying a Dockerfile:

```bash
docker compose -f srcs/docker-compose.yml up --build
```

---

# Managing containers

Start existing containers:

```bash
docker compose -f srcs/docker-compose.yml up -d
```

Stop containers:

```bash
docker compose -f srcs/docker-compose.yml down
```

Restart a service:

```bash
docker compose -f srcs/docker-compose.yml restart nginx
```

List containers:

```bash
docker ps -a
```

Open a shell inside a container:

```bash
docker exec -it wordpress sh
docker exec -it mariadb sh
docker exec -it nginx sh
```

---

# Managing volumes

List volumes:

```bash
docker volume ls
```

Inspect a volume:

```bash
docker volume inspect mariadb_data
```

Remove unused volumes:

```bash
docker volume prune
```

Delete the project's volumes:

```bash
make fclean
```

---

# Data persistence

Persistent data is stored inside Docker named volumes.

| Volume | Contents |
|---------|----------|
| mariadb_data | Database files |
| wordpress_data | WordPress website files |

Because named volumes are used, data remains available even when containers are deleted. The data is only removed when the volumes themselves are deleted.

---

# Useful commands

View logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

Follow logs in real time:

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

Show networks:

```bash
docker network ls
```

Inspect the project network:

```bash
docker network inspect inception
```

Rebuild from scratch:

```bash
make fclean
make
```