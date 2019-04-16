set :output, "log/cron_log.log"
env :PATH, ENV['PATH']

every 2.hours do
  rake "importer:run"
end