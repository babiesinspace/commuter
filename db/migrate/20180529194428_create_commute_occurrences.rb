class CreateCommuteOccurrences < ActiveRecord::Migration[5.2]
  def self.up
    create_table :commute_occurrences do |t|

      t.references :schedulable, polymorphic: true, index: { name: 'idx_com_occur_on_sched_type_and_sched_id' }
      t.datetime :date

      t.timestamps
      
    end
  end

  def self.down
    drop_table :commute_occurrences
  end
end