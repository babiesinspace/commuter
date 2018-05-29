class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :address
      t.numeric :latitude
      t.numeric :longitude
      t.references :locatable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
