# frozen_string_literal: true

module ApplicationMethods

  extend ActiveSupport::Concern

  included do
    before_action :doorkeeper_authorize!, if: proc { request.path.include?('/api') }
    around_action :handle_exceptions,     if: proc { request.path.include?('/api') }
    # protect_from_forgery with: :null_session, if: proc { request.path.include?('/api') }
  end

  def doorkeeper_unauthorized_render_options(*)
    {
      json: {
              "success": false,
              "message": "You are not authorized.",
              "data": {},
              "meta": {},
              "errors": []
            }
    }
  end

  private

  def current_user
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  # Catch exception and return JSON-formatted error
  def handle_exceptions
    begin
      yield
    rescue ActiveRecord::RecordNotFound => e
      @status = 404
      class_name = e.message[/Couldn't find (.*?) with/, 1]
      @message = "Sorry, #{class_name.downcase} not available, Please try something else."
    rescue ActiveRecord::RecordInvalid => e
      render_unprocessable_entity_response(e.record) && return
    rescue ArgumentError => e
      @status = 400
    rescue RuntimeError => e
      json_response({ success: false, message: e.message.to_s, errors: [{ detail: e.message }] }, 409) && return
    rescue StandardError => e
      @status = 500
    end

    json_response({ success: false, message: @message || e.class.to_s, errors: [{ detail: e.message }] }, @status) unless e.class == NilClass
  end

  def render_unprocessable_entity_response(resource)
    json_response({
                    success: false,
                    message: 'Validation Failed',
                    errors: ValidationErrorsSerializer.new(resource).serialize
                  }, 422)
  end

  def render_unprocessable_entity(message = "", status = 422, data = {})
    json_response({
      success: false,
      message: message,
      status: status    
    }, 422) and return false
  end

  def render_success_response(resources = {}, message = '', status = 200, meta = {})
    json_response({
                    success: true,
                    message: message,
                    data: resources,
                    meta: meta
                  }, status)
  end

  def json_response(options = {}, status = 500)
    render json: JsonResponse.new(options), status: status
  end

  def meta_attributes(collection, extra_meta = {})
    return [] if collection.empty?
    (collection).merge(extra_meta)
  end

  def meta_pagination(collection)
    {
      pagination: {
        total_count: collection.total_count
      }
    }
  end

  def render_unauthorized_response
    json_response({
                    success: false,
                    message: 'You are not authorized.'
                  }, 401) && return
  end

  def array_serializer
    ActiveModel::Serializer::CollectionSerializer
  end

  def single_serializer
    ActiveModelSerializers::SerializableResource
  end

end
