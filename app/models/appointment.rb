class Appointment < ApplicationRecord
  
  #Associations
  belongs_to :time_slot
  belongs_to :patient, foreign_key: 'patient_id', class_name: 'Patient'

  #Validations
  validates :appointment_date, presence: true

  validate :validate_appointment, if: Proc.new { |a| a.appointment_date? && a.time_slot_id? }
  after_create :send_email_before_apt


  def send_email_before_apt    
    UserMailer.appointment_reminder(self).deliver!
  end


  def when_to_run
    self.appointment_date - 30.minutes
  end

  def validate_appointment
    current_appointments = current_appointments = Appointment.where(appointment_date: self.appointment_date, time_slot_id: self.time_slot_id).count

     errors.add(:base, 'No appointment available for this slot')  if current_appointments >= self.time_slot.capacity
     date = self.appointment_date.to_date

     unless self.appointment_date.between?(DateTime.new(date.year, date.month, date.day, self.time_slot.start_time.strftime("%H:%M").to_s.split(":")[0].to_i, self.time_slot.start_time.strftime("%H:%M").to_s.split(":")[1].to_i, 00, "+0530"), DateTime.new(date.year, date.month, date.day, self.time_slot.end_time.strftime("%H:%M").to_s.split(":")[0].to_i, self.time_slot.end_time.strftime("%H:%M").to_s.split(":")[1].to_i, 00, "+0530"))
      errors.add(:base, 'No appointment available for this slot')
    end
  end


  handle_asynchronously :send_email_before_apt, :run_at => Proc.new { |i| i.when_to_run}
end
