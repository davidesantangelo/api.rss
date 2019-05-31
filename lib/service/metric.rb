module Service
  class Metric
    API_URL = "https://api.openrank.io//"

    def self.rank(domain)
      api(domain: domain).dig('data', domain, 'openrank').to_i  
    end

    private

    def self.api(domain: )
      response = RestClient.get "#{API_URL}?key=#{ENV['METRIC_KEY']}&d=#{domain}"
      response = JSON.parse(response.body)
      
      response
    rescue RestClient::ExceptionWithResponse => e
      {}
    end
  end
end