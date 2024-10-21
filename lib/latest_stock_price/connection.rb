module LatestStockPrice
  class Connection
    RAPID_API_KEY = ENV.fetch("RAPID_API_KEY", nil)
    RAPID_API_HOST = ENV.fetch("RAPID_API_HOST", nil)
    RAPID_API_BASE_URL = ENV.fetch("RAPID_API_BASE_URL", nil)

    class << self
      def send_request(http_verb, path, body_params: {}, query_params: {})
        response = connection.send(http_verb) do |req|
          req.headers["x-rapidapi-host"] = RAPID_API_HOST
          req.headers["x-rapidapi-key"] = RAPID_API_KEY
          req.body = body_params.to_json
          req.url path, query_params
        end

        logging_request(path, body_params, response)
        raise_standart_error(response)
        json_response(response)
      end

      private

      def connection
        Faraday.new(url: RAPID_API_BASE_URL) do |conn|
          conn.request :json
          conn.response :json, content_type: /\bjson$/
          conn.adapter Faraday.default_adapter
        end
      end

      def json_response(faraday_response)
        { status: faraday_response.status, body: faraday_response.body }.stringify_keys
      end

      def logging_request(path, body_params, response)
        Rails.logger.info "RAPID:REQUEST_URL #{RAPID_API_BASE_URL}"
        Rails.logger.info "RAPID:REQUEST_PATH #{path}"
        Rails.logger.info "RAPID:REQUEST_BODY #{body_params}"
        Rails.logger.info "RAPID:RESPONSE #{json_response(response)}"
      end

      def raise_standart_error(response)
        raise StandardError, response.body["message"] if [ 200, 204 ].exclude?(response.status)
      end
    end
  end
end
