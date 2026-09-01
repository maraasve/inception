*This project has been created as part of the 42 curriculum by `maraasve`.*

# Inception

## Description

**Inception** is a system administration project from the 42 curriculum focused on containerization with Docker.

The goal is to build a small, production-like infrastructure where each service runs inside its own Docker container. The containers communicate through a dedicated Docker network and persist their data using Docker volumes.

This project includes:

- **NGINX** as the only entry point (HTTPS with TLS)
- **WordPress** with PHP-FPM
- **MariaDB** as the database
- Docker Compose for orchestration
- Persistent storage using Docker volumes
- Environment-based configuration through a `.env` file

---

## Project Architecture

```text
.
├── Makefile
├── README.md
└── srcs
    ├── docker-compose.yml
    ├── .env
    └── requirements
        ├── mariadb/
        ├── nginx/
        └── wordpress/
```

### Why this structure?

The `srcs` directory contains the entire infrastructure: the Docker Compose file, environment variables, and the Dockerfiles for each service. Separating each service into its own folder keeps the project modular, organized, and easy to maintain.

---

## How Docker is used

Each service is built from its own custom **Dockerfile**, creating three separate Docker images:

- **NGINX** – reverse proxy and HTTPS server
- **WordPress** – PHP-FPM application
- **MariaDB** – database server

`docker-compose.yml` orchestrates the infrastructure by:

- Building all images
- Creating containers
- Connecting them to the same network
- Mounting persistent volumes
- Starting services in the correct order

This makes the entire environment reproducible on any machine with Docker installed.

---

## Instructions

### Clone the repository

```bash
git clone https://github.com/<your-login>/inception.git
cd inception
```

### Configure environment variables

Create `srcs/.env`:

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

### Build and run

Using the Makefile:

```bash
make
```

Or directly with Docker Compose:

```bash
docker compose -f srcs/docker-compose.yml up --build
```

### Stop containers

```bash
make down
```

### Remove everything

```bash
make fclean
```

This removes containers, images, networks, and volumes.

---

## Main Design Choices

- One service per container
- Custom Dockerfiles based on Debian
- NGINX is the only exposed service
- Internal communication through a Docker bridge network
- Persistent WordPress and MariaDB data stored in named Docker volumes
- Configuration managed with environment variables in `.env`

---

## Comparison

### Virtual Machines vs Docker

| Virtual Machines | Docker |
|------------------|--------|
| Includes a full guest operating system | Shares the host kernel |
| Heavy and slower to start | Lightweight and fast |
| Uses more RAM and storage | More resource efficient |
| Virtualizes an entire machine | Containerizes applications |

Docker is ideal for this project because we only need isolated services, not multiple operating systems.

### Secrets vs Environment Variables

| Docker Secrets | Environment Variables |
|---------------|----------------------|
| Intended for sensitive credentials | Intended for general configuration |
| Better security in production | Simple for local development |
| Managed separately by Docker | Stored in `.env` and injected at runtime |

This project uses environment variables because it is a local educational infrastructure. Production deployments should prefer Docker Secrets for passwords.

### Docker Network vs Host Network

| Docker Bridge Network | Host Network |
|----------------------|-------------|
| Private communication between containers | Shares the host networking stack |
| Better isolation | Less isolation |
| Services communicate using container names | Uses localhost directly |

The project uses a **bridge network** so WordPress can reach MariaDB using the service name (`mariadb`) while remaining isolated from the host.

### Docker Volumes vs Bind Mounts

| Docker Volumes | Bind Mounts |
|---------------|------------|
| Managed by Docker | Maps a host directory |
| Best for persistent application data | Best for editing files live |
| Portable across systems | Depends on the host filesystem |

Named Docker volumes are used to preserve the database and website data even if containers are recreated.

---

## Usage

After starting the project:

1. Open `https://localhost` (or your configured domain).
2. Complete the WordPress installation if needed.
3. Log in using the administrator credentials defined in `.env`.

---

## Resources

### Documentation

- Docker Documentation
- Docker Compose Documentation
- NGINX Documentation
- MariaDB Documentation
- WordPress Documentation
- 42 Inception Subject

### AI Usage

AI was used as a learning and documentation assistant. It helped with:

- Understanding Docker and Docker Compose concepts
- Explaining networks, volumes, and container communication
- Debugging configuration issues
- Improving documentation and README structure

All Dockerfiles, configuration files, and infrastructure were implemented and tested manually.