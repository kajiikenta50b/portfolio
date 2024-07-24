#!/bin/bash
set -e

# Check if the database exists
if ! bundle exec rails db:migrate:status > /dev/null 2>&1; then
  echo "Database doesn't exist. Creating..."
  bundle exec rails db:create
  bundle exec rails db:migrate
else
  # Run any pending migrations
  bundle exec rails db:migrate
fi

# Update crontab with whenever settings
bundle exec whenever --update-crontab

# Start cron service
cron

# Execute the container's main process
exec "$@"
