module Service
  class Dandelion
    API_URL = "https://api.dandelion.eu/"

    def self.entity(text: )
      payload = { 
        text: text, 
        token: ENV['dandelion_token'],
        include: 'types,abstract,categories'
      }

      response = RestClient.post "#{API_URL}datatxt/nex/v1/?", payload

      JSON.parse(response.body)
    end
  end
end