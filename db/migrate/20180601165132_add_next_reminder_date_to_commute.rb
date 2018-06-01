class AddNextReminderDateToCommute < ActiveRecord::Migration[5.2]
  def change
    add_column :commutes, :next_reminder_date, :datetime
  end
end
