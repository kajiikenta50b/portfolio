#!/bin/bash
set -e

# Prepare the database if it doesn't exist
if ! bundle exec rails db:exists; then
  echo "Database doesn't exist. Creating..."
  bundle exec rails db:create
  bundle exec rails db:migrate
fi

# Run any pending migrations
bundle exec rails db:migrate

# Execute the container's main process
exec "$@"

