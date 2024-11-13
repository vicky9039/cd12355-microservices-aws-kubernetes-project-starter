#!/bin/bash

# Set locale
 export LANG=en_US.UTF-8
 #export LC_ALL=en_US.UTF-8

# Set the database password
export DB_PASSWORD=mypassword
export PGPASSWORD="$DB_PASSWORD"

# Execute SQL scripts
psql --host 127.0.0.1 -U myuser -d mydatabase -p 5433 < 1_create_tables.sql
psql --host 127.0.0.1 -U myuser -d mydatabase -p 5433 < 2_seed_users.sql
psql --host 127.0.0.1 -U myuser -d mydatabase -p 5433 < 3_seed_tokens.sql

# Unset the database password for security reasons
#unset PGPASSWORD