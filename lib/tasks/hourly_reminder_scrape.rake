task :hourly_reminder_scrape do
    SetReminderTimeJob.perform_later
end