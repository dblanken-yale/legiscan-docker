# LegiScan API Docker Setup

Docker containerized setup for the LegiScan API Client with MariaDB database.

## Prerequisites

- Docker
- Docker Compose
- LegiScan API Key (get one free at [legiscan.com](https://legiscan.com/legiscan/))

## Quick Start

1. **Copy the environment file**
   ```bash
   cp .env.example .env
   ```

2. **Edit `.env` and add your LegiScan API key**
   ```bash
   vim .env
   # Set LEGISCAN_API_KEY=your_api_key_here
   ```

3. **Start the containers**
   ```bash
   docker-compose up -d
   ```

4. **Initialize the configuration**
   ```bash
   ./init-config.sh
   ```

5. **Access the application**
   - Web UI: http://localhost:8080/legiscan-ui.php
   - Database: localhost:3306

## Services

### MariaDB Database
- **Container**: `legiscan_db`
- **Port**: 3306 (configurable via `DB_PORT` in `.env`)
- **Database**: `legiscan_api`
- **User**: `legiscan_api`
- **Password**: Set in `.env` (default: `legiscan_password`)

The database is automatically initialized with the LegiScan schema on first startup.

### PHP/Apache Application
- **Container**: `legiscan_app`
- **Port**: 8080 (configurable via `APP_PORT` in `.env`)
- **PHP Version**: 8.2
- **Web Server**: Apache

## Configuration

The LegiScan configuration is managed through `legiscan/config.php`. The initialization script (`init-config.sh`) will:
- Create `config.php` from `config.dist.php`
- Configure database connection to use the Docker MariaDB service
- Set your API key from the `.env` file

To manually edit the configuration:
```bash
vim legiscan/config.php
```

## Usage

### Command Line Tools

Execute commands inside the app container:

```bash
# Access the container
docker exec -it legiscan_app bash

# Run CLI commands
php legiscan-cli.php --help
php legiscan-cli.php --masterlist CA
php legiscan-cli.php --bill 823201

# Run bulk import
php legiscan-bulk.php --help
php legiscan-bulk.php --bulk --import --yes
```

### Web Interface

The web UI is available at http://localhost:8080/legiscan-ui.php

Use this to:
- Test API requests
- View payload structures
- Examine API responses

### Database Access

Connect to the MariaDB database:

```bash
# Using Docker
docker exec -it legiscan_db mysql -u legiscan_api -p legiscan_api

# From host (if port 3306 is exposed)
mysql -h 127.0.0.1 -P 3306 -u legiscan_api -p legiscan_api
```

## Volumes

The setup uses Docker volumes for data persistence:

- `db_data`: MariaDB database files
- `app_cache`: LegiScan API cache
- `app_logs`: Application logs

## Stopping and Starting

```bash
# Stop containers
docker-compose down

# Start containers
docker-compose up -d

# Stop and remove volumes (WARNING: deletes all data)
docker-compose down -v

# View logs
docker-compose logs -f

# View logs for specific service
docker-compose logs -f app
docker-compose logs -f db
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DB_ROOT_PASSWORD` | MariaDB root password | `rootpassword` |
| `DB_NAME` | Database name | `legiscan_api` |
| `DB_USER` | Database user | `legiscan_api` |
| `DB_PASSWORD` | Database password | `legiscan_password` |
| `DB_PORT` | Database port (host) | `3306` |
| `APP_PORT` | Application port (host) | `8080` |
| `LEGISCAN_API_KEY` | Your LegiScan API key | (empty) |

## Troubleshooting

### Database connection issues

If the app can't connect to the database:

1. Check if the database is healthy:
   ```bash
   docker-compose ps
   ```

2. Check database logs:
   ```bash
   docker-compose logs db
   ```

3. Verify the database is initialized:
   ```bash
   docker exec -it legiscan_db mysql -u root -p -e "SHOW DATABASES;"
   ```

### Permission issues

If you encounter permission errors:

```bash
docker exec -it legiscan_app chown -R www-data:www-data /var/www/html
docker exec -it legiscan_app chmod -R 755 /var/www/html
```

### Rebuilding containers

If you make changes to the Dockerfile:

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## Additional Resources

- [LegiScan API Documentation](https://api.legiscan.com/docs/index.html)
- [LegiScan API Manual](https://legiscan.com/gaits/documentation/legiscan)
- [LegiScan Client README](legiscan/README.md)

## License

See the LegiScan COPYRIGHT file for licensing information.
