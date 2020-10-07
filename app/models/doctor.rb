class Doctor < User
  has_many :time_slots, foreign_key: 'doctor_id'
  has_many :appointments, through: :time_slots
end
