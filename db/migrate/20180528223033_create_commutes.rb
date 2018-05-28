class CreateCommutes < ActiveRecord::Migration[5.2]
  def change
    create_table :commutes do |t|
      t.string :label
      t.datetime :start_time
      t.text :recurring

      t.timestamps
    end
  end
end
