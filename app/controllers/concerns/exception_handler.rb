module ExceptionHandler
  extend ActiveSupport::Concern

  class Unauthenticated < StandardError; end
  class Forbidden < StandardError; end
  class Invalid < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render_json({ error: e.message }, status: :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render_json({ error: e.message }, status: :unprocessable_entity)
    end

    rescue_from ExceptionHandler::Invalid do |e|
      render_json({ error: e.message }, status: :unprocessable_entity)
    end

    rescue_from ExceptionHandler::Unauthenticated do |e|
      render_json({ error: e.message }, status: :unauthorized)
    end

    rescue_from ExceptionHandler::Forbidden do |e|
      render_json({ error: e.message }, status: :forbidden)
    end
  end
end
