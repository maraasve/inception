# User Documentation

## Overview

This Docker stack provides three services:

| Service | Purpose |
|---------|---------|
| NGINX | HTTPS web server and reverse proxy |
| WordPress | Website and CMS |
| MariaDB | Database used by WordPress |

NGINX is the only service exposed to the host. WordPress communicates with MariaDB through an internal Docker network.

---

# Starting the project

From the root of the repository:

```bash
make
```

This builds the Docker images (if necessary) and starts all containers.

---

# Stopping the project

Stop the containers:

```bash
make down
```

Remove containers, images and volumes:

```bash
make fclean
```

---

# Accessing the website

Open your browser and visit:

```text
https://localhost
```

If your project uses a custom domain, use the value defined in `.env` instead.

---

# Accessing the WordPress admin panel

Go to:

```text
https://localhost/wp-admin
```

Log in using the administrator credentials defined in the `.env` file.

---

# Credentials

All credentials are stored inside:

```text
srcs/.env
```

Important variables include:

- `MYSQL_DATABASE`
- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `MYSQL_ROOT_PASSWORD`
- `WP_ADMIN_USER`
- `WP_ADMIN_PASSWORD`
- `WP_ADMIN_EMAIL`

Update these values before launching the project if needed.

---

# Checking that services are running

Display running containers:

```bash
docker ps
```

Expected containers:

- nginx
- wordpress
- mariadb

Check container logs:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

You can also verify that the website loads correctly by opening it in a browser over HTTPS.