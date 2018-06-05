### Procfile ###

web: bundle exec puma -C config/puma.rb config.ru
worker: bundle exec rake schedule_and_work COUNT=1 QUEUE=* TERM_CHILD=1 RESQUE_TERM_TIMEOUT=10