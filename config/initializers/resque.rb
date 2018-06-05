require 'resque/server'
require 'resque-scheduler'
require 'resque/scheduler/server'
require 'resque-retry'
require 'resque-retry/server'
require 'resque/failure/redis'

uri = URI.parse(ENV["REDIS_URL"])
Resque.redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)


Resque.after_fork = proc {
    ActiveRecord::Base.establish_connection
}


Resque::Failure::MultipleWithRetrySuppression.classes = [Resque::Failure::Redis]
Resque::Failure.backend = Resque::Failure::MultipleWithRetrySuppression