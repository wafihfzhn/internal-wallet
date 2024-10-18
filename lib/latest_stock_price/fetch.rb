module LatestStockPrice
  class Fetch < Connection
    class << self
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
