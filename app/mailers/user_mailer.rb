class UserMailer < ApplicationMailer

  def appointment_reminder appointment
    @user = appointment.patient
    @doctor = appointment.time_slot.doctor
    @appointment = appointment
    mail(to: @user.email, subject: 'Appointment Reminder')
  end
end
