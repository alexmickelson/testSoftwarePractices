#!/bin/bash
set -e

# Set the replication user password
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  ALTER USER $POSTGRES_USER WITH REPLICATION;
EOSQL

# Set up the replication slot
until PGPASSWORD=$POSTGRES_PASSWORD pg_basebackup -h $REPLICATE_FROM -U $POSTGRES_USER -D $PGDATA -P -R -X stream -c fast -S pg_replica_slot; do
  echo "Failed to set up replication, retrying in 5 seconds..."
  sleep 5
done
