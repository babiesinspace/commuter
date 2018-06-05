# Scheduler needs very little cpu, just start it with a worker.
desc "schedule and work, so we only need 1 dyno"
task :schedule_and_work => [ :environment ] do
  if Process.fork
    sh "rake environment resque:work"
  else
    sh "rake resque:scheduler"
    Process.wait
  end
end