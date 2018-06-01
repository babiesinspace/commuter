class SendTextJob < ApplicationJob
  @queue = :send_reminder_text

    def perform(reminder_id)
      reminder = Reminder.find(reminder_id)
      reminder.reminder
    end
    
end 