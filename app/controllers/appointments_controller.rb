class AppointmentsController < ApplicationController

  before_action :check_user, only: [:index]

  def create
    appointment = current_user.appointments.new(appointment_params)
    if appointment.save 
      render_success_response({appointment: single_serializer.new(appointment, serializer: AppointmentSerializer)}, 'Appointment is added successfully.',201)
    else
      render json: {error: appointment.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def available_slots
    d = params[:date]
    current_appointments = Appointment.where("DATE(appointment_date) = ?", d.to_date).group(:time_slot_id).count
    total_capacity = TimeSlot.select(:id, :capacity).as_json
    available_slot_ids = []
    total_capacity.each do |k|

      available_slot_ids.push(k['id']) if k['capacity'] > (current_appointments[k['id']] ? current_appointments[k['id']] : 0)
    end
    available_slots = TimeSlot.where(id: available_slot_ids)
    if available_slots.present?
          json_response({
          success: true,
          data: {
            time_slots: array_serializer.new(available_slots, serializer: TimeSlotSerializer)
          }
        }, 200)
    else
      render_success_response({}, 'No available slots found for selected date.', 200)
    end
  end

  def index
    appointments = current_user.appointments
    json_response({
      success: true,
      data: {
        appointments: array_serializer.new(appointments, serializer: AppointmentSerializer)
      }
    }, 200)
  end

  private

  def appointment_params
    params.require(:appointment).permit(:id,:time_slot_id, :appointment_date, :user_id)
  end

  def check_user
    if current_user.patient?
      json_response({ success: false, message: "Not Authorized."}, 404)
    end
  end
end
