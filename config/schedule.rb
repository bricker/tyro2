# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
 set :output, "/home/birnvps/tyro2/shared/log/cron.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever


#### NOTE: Remember that these times are the time of the server, not what Rails has set.
job_type :command_current, 'cd :path && :task :output'
job_type :rake, "cd :path && RAILS_ENV=:environment bundle exec rake :task --silent :output" # redefining this because it doesn't use `bundle exec` for some reason

every :day, :at => '1 am' do
  command_current "bash script/mysql_backup.sh"
end
# split these up to keep memory usage down
every :day, :at => '2 am' do
  runner "Topic.cleanup_read_marks!"
  command_current "RAILS_ENV=production script/delayed_job restart"
end

# This does two things: 1) Indexes data so the search results stay relatively fresh, and 2) Stops and starts search daemon
every 2.hours do
  rake "thinking_sphinx:index"
end

every :sunday, :at => '1:30 am' do
  runner "Event.cleanup_old_events"
end