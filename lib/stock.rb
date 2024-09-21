require 'net/http'
require 'uri'

class Stock
    def self.price_all
        url = URI.parse('https://latest-stock-price.p.rapidapi.com/any')
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true if url.scheme == 'https'

        request = Net::HTTP::Get.new(url)

        request['Content-Type'] = 'application/json'
        request['x-rapidapi-host'] = 'latest-stock-price.p.rapidapi.com'
        request['x-rapidapi-key'] = ENV.fetch("X_RAPIDAPI_KEY")
        response = http.request(request)
        case response
        when Net::HTTPSuccess
            puts "Success! Response code: #{response.code}"
            return JSON.parse(response.body)
        else
            raise StandardError, "Error while fetching stock prices. Response code: #{response.code}"
        end
    end
end