class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.datetime :appointment_date
      t.references :patient, references: :users, foreign_key: { to_table: :users}
      t.references :time_slot, foreign_key: true

      t.timestamps
    end
  end
end
