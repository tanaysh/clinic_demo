class TimeSlotsController < ApplicationController

  before_action :check_user, only: [:index, :create]
  
  def create
    time_slot = current_user.time_slots.new(time_slot_params)
    if time_slot.save
      render_success_response({time_slot: single_serializer.new(time_slot, serializer: TimeSlotSerializer)}, 'Time Slot is added successfully.',201)
    else
      render json: {error: time_slot.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def index
    @time_slots = current_user.time_slots
    json_response({
      success: true,
      data: {
        time_slots: array_serializer.new(@time_slots, serializer: TimeSlotSerializer)
      }
    }, 200)
  end


  private

  def time_slot_params
    params.require(:time_slot).permit(:id,:start_time,:end_time,:capacity)
  end

  def check_user
    if current_user.patient?
      json_response({ success: false, message: "Not Authorized."}, 404)
    end
  end
end
