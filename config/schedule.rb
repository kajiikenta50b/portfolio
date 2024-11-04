# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
#
set :output, "log/cron_log.log"
set :environment, "production" # 必要に応じて"development/production"に変更

every :monday, at: '12am' do
  rake "faction_rank:calculate_top"
end

every 1.minute do
  command "echo 'Cron is working!' >> /rails/log/cron.log"
end

# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
