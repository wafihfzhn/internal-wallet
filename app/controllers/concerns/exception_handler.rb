module ExceptionHandler
  extend ActiveSupport::Concern

  class Unauthenticated < StandardError; end
  class Forbidden < StandardError; end
  class Invalid < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { error: { message: "#{e.model} not found" } }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      errors_sentence = e.record.errors.full_messages.to_sentence
      render json: { error: { message: errors_sentence } }, status: :unprocessable_entity
    end

    rescue_from ExceptionHandler::Invalid do |e|
      render json: { error: { message: e.message } }, status: :unprocessable_entity
    end

    rescue_from ExceptionHandler::Unauthenticated do |e|
      render json: { error: { message: e.message } }, status: :unauthorized
    end

    rescue_from ExceptionHandler::Forbidden do |e|
      render json: { error: { message: e.message } }, status: :forbidden
    end
  end
end
