class AddTextTimeToReminders < ActiveRecord::Migration[5.2]
  def change
    add_column :reminders, :text_time, :datetime
  end
end
