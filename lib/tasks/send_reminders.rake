task :send_reminders do
    SendTextJob.perform_later
end