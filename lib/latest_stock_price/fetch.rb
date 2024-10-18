module LatestStockPrice
  class Fetch < Connection
    class << self
      def equities_enhanced(query_params = {})
        path = "/equities-enhanced"
        send_request("get", path, query_params: query_params)
      end

      def equities
        path = "/equities"
        send_request("get", path)
      end

      def price_all
        path = "/any"
        send_request("get", path)
      end
    end
  end
end
