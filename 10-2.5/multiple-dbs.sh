#!/bin/bash
set -e
set -u
set -x

function create_user_and_database() {
  local database=$1
  echo "  Creating database '$database'"
  psql -U $POSTGRES_USER -v ON_ERROR_STOP=1 -d postgres  <<-EOSQL
      CREATE DATABASE $database;
      GRANT ALL PRIVILEGES ON DATABASE $database TO $POSTGRES_USER;
EOSQL
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
  echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
  for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
    create_user_and_database $db
  done
  echo "Multiple databases created"
fi
