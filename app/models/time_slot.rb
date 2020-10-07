class TimeSlot < ApplicationRecord
  
  #Associations
  belongs_to :doctor, :foreign_key => "doctor_id", :class_name => "Doctor"
  has_many :appointments

  #Validations
  validates :start_time,:end_time, presence: true
  validate :valid_time_slot, if: Proc.new { |a| a.start_time? && a.end_time? }



  def valid_time_slot
    if self.end_time.to_time < self.start_time.to_time
      errors.add(:end_time, 'must be greater then start time')
    end
  end
end
