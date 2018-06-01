class AddDurationToCommute < ActiveRecord::Migration[5.2]
  def change
    add_column :commutes, :duration, :integer
  end
end
