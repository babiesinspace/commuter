class Reminder < ApplicationRecord
  belongs_to :commute

  # Returns ActiveRecord::Relation with reminders
  def self.grab_daily
    self.where(start_time: Date.today.all_day)
  end 

end
