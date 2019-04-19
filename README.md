# FEEDI

Feedi turn feed data into a fantastic API.

Feedi simplifies how you handle RSS, Atom, or JSON feeds. You can add and keep track of your favourite feed data with a simple and clean REST API.

### AUTHENTICATION

Feedi API uses OAuth 2.0 token for user authorization and API authentication. Applications must be authorized and authenticated before they can fetch data.

#### GET TOKEN

    # POST /tokens
``` ruby
RestClient.post "https://feedi.me/tokens", {}
```

#### REFRESH TOKEN
    
    # POST /tokens/refresh
``` ruby
RestClient.post "https://feedi.me/tokens/refresh", {}, { Authorization: "Token #{TOKEN}" }
```

#### CURRENT TOKEN
    
    # GET /tokens/current
``` ruby
RestClient.get "https://feedi.me/tokens/current", { Authorization: "Token #{TOKEN}" }
```
    
#### RESPONSE
``` json
{
  "data": {
    "id": "f1af9186-36a7-4320-b533-570d8944b2dd",
    "type": "token",
    "attributes": {
      "key": "UQ4sLxr1tXBX4c2e3GiG6Q2LzG7yMRuhi-LGDJqB0kJjXVtYKVyrTMyP2HtTyZpEuD71rvJy9Tn4SmHBtiimHg",
      "expires_at": 1554804514,
      "active": true
    }
  }
}
```

### FEEDS

FEEDS RSS (originally RDF Site Summary; later, two competing approaches emerged, which used the backronyms Rich Site Summary and Really Simple Syndication respectively) is a type of web feed which allows users and applications to access updates to online content in a standardized, computer-readable format.

#### INDEX FEEDS
    
    # GET /feeds

``` ruby
RestClient.get "https://feedi.me/feeds", { Authorization: "Token #{TOKEN}" }
```

#### SHOW FEED
    
    # GET /feeds/:id

``` ruby
RestClient.get "https://feedi.me/feeds/{id}", { Authorization: "Token #{TOKEN}" }
```

#### CREATE FEED
    
    # POST /feeds
    
``` ruby
payload = { url: "http://www.repubblica.it/rss/homepage/rss2.0.xml" }

headers = { Authorization: "Token #{TOKEN}", content_type: :json, accept: :json }

RestClient.post "https://feedi.me/feeds", payload.to_json, headers
    
```

#### INDEX FEEDS
    
    # GET /feeds/popular

``` ruby
RestClient.get "https://feedi.me/feeds/popular", { Authorization: "Token #{TOKEN}" }
```
