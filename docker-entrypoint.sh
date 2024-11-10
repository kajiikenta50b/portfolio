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

# Check if the cron service is already running, and clear any stale PID file
if [ -f /var/run/crond.pid ]; then
  if ! pgrep -x "cron" > /dev/null; then
    echo "Stale cron PID file found. Removing..."
    rm -f /var/run/crond.pid
  fi
fi

# Start cron service
service cron start

# Execute the container's main process
exec "$@"
