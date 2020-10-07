class TimeSlotSerializer < ActiveModel::Serializer

  attributes :id, :start_time, :end_time, :capacity

  # belongs_to :user, :foreign_key => "user_id", class_name: 'Doctor'
end
