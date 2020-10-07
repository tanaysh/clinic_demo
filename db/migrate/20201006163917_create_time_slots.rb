class CreateTimeSlots < ActiveRecord::Migration[5.2]
  def change
    create_table :time_slots do |t|
      t.time :start_time
      t.time :end_time
      t.integer :capacity, default: 0
      t.references :doctor, references: :users, foreign_key: { to_table: :users}

      t.timestamps
    end
  end
end
