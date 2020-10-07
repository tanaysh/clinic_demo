class AppointmentSerializer < ActiveModel::Serializer

  attributes :id, :appointment_date

  belongs_to :time_slot
  belongs_to :patient
end
