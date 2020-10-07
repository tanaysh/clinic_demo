class UserSerializer < ActiveModel::Serializer

  attributes :id, :email, :name, :type

  # has_many :time_slots, key: "time_slots", serializer: TimeSlotSerializer, :foreign_key => "user_id", class_name: 'Doctor'
  attribute :time_slots, if: :is_doctor?

  def is_doctor?
    object.time_slots if object.doctor?
  end
end

