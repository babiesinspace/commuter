class CreateReminders < ActiveRecord::Migration[5.2]
  def change
    create_table :reminders do |t|
      t.references :commute
      t.datetime :start_time

      t.timestamps
    end
  end
end
