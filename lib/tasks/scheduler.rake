# Scheduler needs very little cpu, just start it with a worker.
desc "schedule and work, so we only need 1 dyno"
task :schedule_and_work => [ :environment ] do
  if Process.fork
    sh "rake environment resque:work"
  else
    sh "rake resque:scheduler RAILS_ENV=production"
    Process.wait
  end
end

task :hourly_reminder_scrape => [ :environment ] do
    SetReminderTimeJob.perform_later
end

task :nightly_commute_job => [ :environment ] do
    CommuteJob.perform_later
end

task :send_reminders => [ :environment ] do
    SendTextJob.perform_later
end