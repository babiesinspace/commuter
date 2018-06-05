require 'resque/server'
require 'resque-scheduler'
require 'resque/scheduler/server'

uri = URI.parse(ENV["REDIS_URL"])
Resque.redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
Resque::Scheduler.dynamic = true
Resque.schedule = YAML.load_file('config/resque_schedule.yml')


Resque.after_fork = proc {
    ActiveRecord::Base.establish_connection
}
