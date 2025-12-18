# Docker CLI Reference for LegiScan

Complete guide to running all LegiScan CLI commands through Docker.

## Table of Contents

- [Quick Reference](#quick-reference)
- [Container Management](#container-management)
- [CLI Commands](#cli-commands)
  - [legiscan-cli.php](#legiscan-cliphp)
  - [legiscan-bulk.php](#legiscan-bulkphp)
  - [legiscand.php](#legiscandphp)
  - [upgrade.php](#upgradephp)
- [Database Access](#database-access)
- [Troubleshooting](#troubleshooting)

---

## Quick Reference

### Start/Stop Containers

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# Stop and remove all data (WARNING: deletes database)
docker-compose down -v

# View logs
docker-compose logs -f

# View app logs only
docker-compose logs -f app

# Check status
docker-compose ps
```

### Access Container Shell

```bash
# Interactive shell
docker exec -it legiscan_app bash

# Run single command
docker exec -it legiscan_app <command>
```

---

## Container Management

### Building and Rebuilding

```bash
# Build containers
docker-compose build

# Rebuild without cache
docker-compose build --no-cache

# Build and start
docker-compose up -d --build
```

### Monitoring

```bash
# View all container logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f app
docker-compose logs -f db

# View last 100 lines
docker-compose logs --tail=100 app

# Check resource usage
docker stats legiscan_app legiscan_db
```

### Maintenance

```bash
# Restart services
docker-compose restart

# Restart specific service
docker-compose restart app

# Stop without removing
docker-compose stop

# Start stopped containers
docker-compose start

# Remove stopped containers
docker-compose rm
```

---

## CLI Commands

All PHP CLI commands should be run inside the `legiscan_app` container. You can either:

1. **Run commands directly** from host:
   ```bash
   docker exec -it legiscan_app php <script.php> <args>
   ```

2. **Enter container shell** and run commands:
   ```bash
   docker exec -it legiscan_app bash
   php <script.php> <args>
   ```

---

### legiscan-cli.php

Main CLI tool for importing specific objects and managing the database.

#### Help and Information

```bash
# Show help
docker exec -it legiscan_app php legiscan-cli.php --help

# Dry run mode (shows what would happen without making changes)
docker exec -it legiscan_app php legiscan-cli.php --dry-run --masterlist CA

# Debug output
docker exec -it legiscan_app php legiscan-cli.php --debug --masterlist CA

# Verbose output
docker exec -it legiscan_app php legiscan-cli.php --verbose --masterlist CA
```

#### Importing Data

```bash
# Import master list for a state
docker exec -it legiscan_app php legiscan-cli.php --masterlist CA
docker exec -it legiscan_app php legiscan-cli.php --masterlist TX

# Import all states (use with caution - high API usage)
docker exec -it legiscan_app php legiscan-cli.php --masterlist ALL

# Import specific bill by ID
docker exec -it legiscan_app php legiscan-cli.php --bill 823201

# Import bill with all related data
docker exec -it legiscan_app php legiscan-cli.php --bill 823201 --import all

# Import session information
docker exec -it legiscan_app php legiscan-cli.php --session 1234
```

#### Search Operations

```bash
# Run national search
docker exec -it legiscan_app php legiscan-cli.php --search "term1 term2" --state ALL

# Search specific state
docker exec -it legiscan_app php legiscan-cli.php --search "healthcare" --state CA

# Search with relevance score filter
docker exec -it legiscan_app php legiscan-cli.php --search "citizens ADJ united" --state ALL --score 75

# Search and import results
docker exec -it legiscan_app php legiscan-cli.php --search "climate" --state ALL --import new

# Advanced search query with operators
docker exec -it legiscan_app php legiscan-cli.php --search "gun AND (control OR regulation)" --state ALL
```

#### Monitor List Management

```bash
# Add bill to monitor list
docker exec -it legiscan_app php legiscan-cli.php --monitor 823882

# Remove bill from monitor list
docker exec -it legiscan_app php legiscan-cli.php --unmonitor 823882

# Show monitor list
docker exec -it legiscan_app php legiscan-cli.php --monitorlist

# Import all monitored bills
docker exec -it legiscan_app php legiscan-cli.php --monitorlist --import all

# Sync monitored bills
docker exec -it legiscan_app php legiscan-cli.php --monitorlist --sync

# Import new changes to monitored bills
docker exec -it legiscan_app php legiscan-cli.php --monitorlist --import new
```

#### Ignore List Management

```bash
# Add bill to ignore list
docker exec -it legiscan_app php legiscan-cli.php --ignore 898381

# Remove bill from ignore list
docker exec -it legiscan_app php legiscan-cli.php --unignore 898381

# Show ignore list
docker exec -it legiscan_app php legiscan-cli.php --ignorelist
```

#### Cache Management

```bash
# Clean API cache
docker exec -it legiscan_app php legiscan-cli.php --clean

# Clean with verbose output
docker exec -it legiscan_app php legiscan-cli.php --clean --verbose

# Dry run to see what would be cleaned
docker exec -it legiscan_app php legiscan-cli.php --clean --dry-run
```

#### Complex Examples

```bash
# Import California master list with verbose output
docker exec -it legiscan_app php legiscan-cli.php --masterlist CA --verbose

# Search and import high-relevance bills
docker exec -it legiscan_app php legiscan-cli.php \
  --search "climate change" \
  --state ALL \
  --score 80 \
  --import new \
  --verbose

# Sync monitor list and import changes
docker exec -it legiscan_app php legiscan-cli.php \
  --monitorlist \
  --sync \
  --import new \
  --verbose

# Test run with debug (no changes made)
docker exec -it legiscan_app php legiscan-cli.php \
  --masterlist CA \
  --dry-run \
  --debug
```

---

### legiscan-bulk.php

Bulk import utility for processing JSON dataset archives.

#### Help and Information

```bash
# Show help
docker exec -it legiscan_app php legiscan-bulk.php --help

# Dry run mode
docker exec -it legiscan_app php legiscan-bulk.php --bulk --import --dry-run

# Debug output
docker exec -it legiscan_app php legiscan-bulk.php --bulk --import --debug

# Verbose output
docker exec -it legiscan_app php legiscan-bulk.php --bulk --import --verbose
```

#### Bulk Import Operations

```bash
# Bulk import using config.php settings (interactive)
docker exec -it legiscan_app php legiscan-bulk.php --bulk --import

# Bulk import with automatic yes (non-interactive)
docker exec -it legiscan_app php legiscan-bulk.php --bulk --import --yes

# Bulk import with verbose output
docker exec -it legiscan_app php legiscan-bulk.php --bulk --import --yes --verbose
```

#### Scan Operations

```bash
# Scan available datasets (list all)
docker exec -it legiscan_app php legiscan-bulk.php --scan

# Scan by state
docker exec -it legiscan_app php legiscan-bulk.php --scan --state CA
docker exec -it legiscan_app php legiscan-bulk.php --scan --state TX

# Scan by year
docker exec -it legiscan_app php legiscan-bulk.php --scan --year 2020
docker exec -it legiscan_app php legiscan-bulk.php --scan --year 2021

# Scan by state and year
docker exec -it legiscan_app php legiscan-bulk.php --scan --state CA --year 2020

# Scan special sessions
docker exec -it legiscan_app php legiscan-bulk.php --scan --special
docker exec -it legiscan_app php legiscan-bulk.php --scan --state NC --special --year 2016
```

#### Scan and Import

```bash
# Scan and import by state
docker exec -it legiscan_app php legiscan-bulk.php --scan --state CA --import --yes

# Scan and import by year
docker exec -it legiscan_app php legiscan-bulk.php --scan --year 2020 --import --yes

# Scan and import special sessions
docker exec -it legiscan_app php legiscan-bulk.php \
  --scan \
  --state NC \
  --special \
  --year 2016 \
  --import \
  --yes

# Import with verbose output
docker exec -it legiscan_app php legiscan-bulk.php \
  --scan \
  --state CA \
  --year 2021 \
  --import \
  --yes \
  --verbose
```

#### File Operations

```bash
# Process specific file
docker exec -it legiscan_app php legiscan-bulk.php --file /path/to/dataset.zip --import --yes

# Process file (dry run)
docker exec -it legiscan_app php legiscan-bulk.php --file /path/to/dataset.zip --dry-run

# Process file with debug
docker exec -it legiscan_app php legiscan-bulk.php --file /path/to/dataset.zip --debug
```

#### Complex Examples

```bash
# Full California 2021 import
docker exec -it legiscan_app php legiscan-bulk.php \
  --scan \
  --state CA \
  --year 2021 \
  --import \
  --yes \
  --verbose

# Import all 2020 datasets
docker exec -it legiscan_app php legiscan-bulk.php \
  --scan \
  --year 2020 \
  --import \
  --yes

# Test import without making changes
docker exec -it legiscan_app php legiscan-bulk.php \
  --scan \
  --state TX \
  --year 2021 \
  --dry-run \
  --verbose
```

---

### legiscand.php

Pull API daemon for continuous synchronization. Typically run as a background service.

#### Running the Daemon

```bash
# Start daemon in foreground (for testing)
docker exec -it legiscan_app php legiscand.php

# Start daemon in background
docker exec -d legiscan_app php legiscand.php

# Start with output to log file
docker exec -d legiscan_app bash -c "php legiscand.php > /var/www/html/log/daemon.log 2>&1"
```

#### Managing the Daemon Process

```bash
# Check if daemon is running
docker exec -it legiscan_app ps aux | grep legiscand

# Stop daemon (find process ID first)
docker exec -it legiscan_app pkill -f legiscand.php

# View daemon logs (if logging to file)
docker exec -it legiscan_app tail -f /var/www/html/log/daemon.log
```

#### Signal Files

The daemon can be controlled via signal files in the `signal/` directory:

```bash
# Pause daemon
docker exec -it legiscan_app touch /var/www/html/signal/legiscand.pause

# Resume daemon
docker exec -it legiscan_app rm /var/www/html/signal/legiscand.pause

# Stop daemon gracefully
docker exec -it legiscan_app touch /var/www/html/signal/legiscand.stop

# Force stop and exit
docker exec -it legiscan_app touch /var/www/html/signal/legiscand.exit
```

#### Configuration

Daemon behavior is configured in `config.php`. Common modes:

- **Monitor**: Track specific bills from `ls_monitor` table
- **State**: Synchronize state master lists
- **Search**: National search synchronization
- **State Search**: State-specific search

---

### upgrade.php

Database schema upgrade utility.

#### Running Upgrades

```bash
# Run database upgrade
docker exec -it legiscan_app php upgrade.php

# Run with dry run to see what would change
docker exec -it legiscan_app php upgrade.php --dry-run

# Run with verbose output
docker exec -it legiscan_app php upgrade.php --verbose
```

#### Before Upgrading

```bash
# Backup database first
docker exec legiscan_db mysqldump -u legiscan_api -plegiscan_password legiscan_api > backup.sql

# Or use Docker volume backup
docker run --rm \
  --volumes-from legiscan_db \
  -v $(pwd):/backup \
  alpine tar czf /backup/db_backup.tar.gz /var/lib/mysql
```

---

## Database Access

### MySQL Command Line

```bash
# Access MySQL as application user
docker exec -it legiscan_db mysql -u legiscan_api -plegiscan_password legiscan_api

# Access MySQL as root
docker exec -it legiscan_db mysql -u root -prootpassword

# Run single query
docker exec -it legiscan_db mysql -u legiscan_api -plegiscan_password legiscan_api \
  -e "SELECT COUNT(*) FROM ls_bill;"
```

### From Host Machine

If you've exposed the database port (default 3306):

```bash
# Connect from host
mysql -h 127.0.0.1 -P 3306 -u legiscan_api -plegiscan_password legiscan_api

# Or with environment variable
mysql -h 127.0.0.1 -P ${DB_PORT} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME}
```

### Database Backups

```bash
# Backup database
docker exec legiscan_db mysqldump \
  -u legiscan_api \
  -plegiscan_password \
  legiscan_api > legiscan_backup_$(date +%Y%m%d).sql

# Restore database
docker exec -i legiscan_db mysql \
  -u legiscan_api \
  -plegiscan_password \
  legiscan_api < legiscan_backup.sql

# Backup with compression
docker exec legiscan_db mysqldump \
  -u legiscan_api \
  -plegiscan_password \
  legiscan_api | gzip > legiscan_backup_$(date +%Y%m%d).sql.gz
```

### Database Queries

```bash
# Count bills
docker exec -it legiscan_db mysql -u legiscan_api -plegiscan_password legiscan_api \
  -e "SELECT COUNT(*) as total_bills FROM ls_bill;"

# List tables
docker exec -it legiscan_db mysql -u legiscan_api -plegiscan_password legiscan_api \
  -e "SHOW TABLES;"

# Check database size
docker exec -it legiscan_db mysql -u legiscan_api -plegiscan_password legiscan_api \
  -e "SELECT table_schema AS 'Database',
      ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)'
      FROM information_schema.TABLES
      WHERE table_schema = 'legiscan_api';"
```

---

## Troubleshooting

### Container Issues

```bash
# View container logs
docker-compose logs -f app
docker-compose logs -f db

# Check container status
docker-compose ps

# Restart containers
docker-compose restart

# Rebuild containers
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Permission Issues

```bash
# Fix file permissions
docker exec -it legiscan_app chown -R www-data:www-data /var/www/html

# Fix directory permissions
docker exec -it legiscan_app chmod -R 755 /var/www/html

# Fix cache directory
docker exec -it legiscan_app chmod -R 777 /var/www/html/cache

# Fix log directory
docker exec -it legiscan_app chmod -R 777 /var/www/html/log
```

### Database Issues

```bash
# Check database connection
docker exec -it legiscan_db mysql -u legiscan_api -plegiscan_password \
  -e "SELECT 1;"

# Check database health
docker exec -it legiscan_db mysql -u root -prootpassword \
  -e "SHOW DATABASES;"

# Reinitialize database (WARNING: deletes all data)
docker-compose down -v
docker-compose up -d
```

### Configuration Issues

```bash
# View current config
docker exec -it legiscan_app cat config.php

# Reinitialize config
./init-config.sh

# Edit config manually
docker exec -it legiscan_app vim config.php
```

### Cache Issues

```bash
# Clear API cache
docker exec -it legiscan_app php legiscan-cli.php --clean --verbose

# Clear cache directory manually
docker exec -it legiscan_app rm -rf /var/www/html/cache/api/*
docker exec -it legiscan_app rm -rf /var/www/html/cache/doc/*

# Recreate cache directories
docker exec -it legiscan_app mkdir -p /var/www/html/cache/api
docker exec -it legiscan_app mkdir -p /var/www/html/cache/doc
docker exec -it legiscan_app chmod -R 777 /var/www/html/cache
```

### Debugging

```bash
# Interactive shell for debugging
docker exec -it legiscan_app bash

# Check PHP version
docker exec -it legiscan_app php -v

# Check PHP extensions
docker exec -it legiscan_app php -m

# Check Apache status
docker exec -it legiscan_app apache2ctl status

# Check Apache configuration
docker exec -it legiscan_app apache2ctl -t

# View Apache error log
docker exec -it legiscan_app tail -f /var/log/apache2/error.log

# View Apache access log
docker exec -it legiscan_app tail -f /var/log/apache2/access.log
```

### Resource Monitoring

```bash
# Monitor container resources
docker stats legiscan_app legiscan_db

# Check disk usage
docker exec -it legiscan_app df -h

# Check database volume size
docker volume inspect legiscan_db_data

# List all volumes
docker volume ls

# Clean up unused Docker resources
docker system prune
docker volume prune
```

---

## Common Workflows

### Initial Setup

```bash
# 1. Configure environment
cp .env.example .env
# Edit .env and add LEGISCAN_API_KEY

# 2. Start containers
docker-compose up -d

# 3. Initialize configuration
./init-config.sh

# 4. Verify setup
docker-compose ps
docker-compose logs -f
```

### Import California Bills

```bash
# Import master list
docker exec -it legiscan_app php legiscan-cli.php --masterlist CA --verbose

# Or use bulk import for historical data
docker exec -it legiscan_app php legiscan-bulk.php \
  --scan --state CA --year 2021 --import --yes --verbose
```

### Monitor Specific Bills

```bash
# Add bills to monitor
docker exec -it legiscan_app php legiscan-cli.php --monitor 823882
docker exec -it legiscan_app php legiscan-cli.php --monitor 823201

# Check monitor list
docker exec -it legiscan_app php legiscan-cli.php --monitorlist

# Sync monitored bills
docker exec -it legiscan_app php legiscan-cli.php --monitorlist --sync --import new
```

### Run Continuous Sync

```bash
# Start daemon in background
docker exec -d legiscan_app bash -c "php legiscand.php > /var/www/html/log/daemon.log 2>&1"

# Monitor daemon logs
docker exec -it legiscan_app tail -f /var/www/html/log/daemon.log
```

### Backup and Restore

```bash
# Backup database
docker exec legiscan_db mysqldump -u legiscan_api -plegiscan_password legiscan_api \
  > backup_$(date +%Y%m%d).sql

# Stop containers
docker-compose down

# Restore database
docker-compose up -d
sleep 10  # Wait for database to be ready
docker exec -i legiscan_db mysql -u legiscan_api -plegiscan_password legiscan_api \
  < backup_20240101.sql
```

---

## Environment Variables

All environment variables are defined in `.env`:

```bash
# Database Configuration
DB_ROOT_PASSWORD=rootpassword
DB_NAME=legiscan_api
DB_USER=legiscan_api
DB_PASSWORD=legiscan_password
DB_PORT=3306

# Application Configuration
APP_PORT=8080

# LegiScan API
LEGISCAN_API_KEY=your_api_key_here
```

To change any setting:

```bash
# 1. Edit .env file
vim .env

# 2. Restart containers
docker-compose down
docker-compose up -d

# 3. Reinitialize config if needed
./init-config.sh
```

---

## Additional Resources

- Main README: `README.md`
- LegiScan Client Documentation: `legiscan/README.md`
- Configuration Template: `legiscan/config.dist.php`
- Database Schema: `legiscan/schema-mysql.sql`

For more information about LegiScan API:
- https://legiscan.com/legiscan
