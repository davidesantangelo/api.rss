module Service
  class Dandelion
    API_URL = "https://api.dandelion.eu/"

    def self.annotations(text: )
      payload = { 
        text: text, 
        token: ENV['dandelion_token'],
        include: 'types,categories',
        top_entities: 5
      }

      response = api(action: 'nex', payload: payload)
      response.fetch('annotations', nil)
    end

    def self.sentiment(text: )
      payload = { 
        text: text, 
        token: ENV['dandelion_token']
      }

      response = api(action: 'sent', payload: payload)
      response.fetch('sentiment', nil)
    end


    def self.api(action: , payload: {})
      response = RestClient.post "#{API_URL}datatxt/#{action}/v1/?", payload
      response = JSON.parse(response.body)
      
      response
    end
  end
end