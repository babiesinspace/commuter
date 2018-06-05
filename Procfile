### Procfile ###

web: bundle exec puma -C config/puma.rb config.ru
worker: env TERM_CHILD=1 QUEUE=* bundle exec rake environment resque:work
scheduler: bundle exec rake resque:scheduler