class SetReminderTimeJob < ApplicationJob
  @queue = :set_reminders

  def perform
    reminders_this_hour = Reminder.grab_hourly
    reminders_this_hour.each do |reminder|
      SendTextJob.set(queue: :send_reminder_text, wait_until: reminder.text_time).perform_later(reminder.id)
    end
  end

end