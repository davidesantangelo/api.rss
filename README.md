# FEEDI

Feedi turn feed data into a fantastic API.

Feedi simplifies how you handle RSS, Atom, or JSON feeds. You can add and keep track of your favourite feed data with a simple and clean REST API.

## AUTHENTICATION

Feedi API uses OAuth 2.0 token for user authorization and API authentication. Applications must be authorized and authenticated before they can fetch data.

### GET TOKEN

    curl -X POST  https://api.feedi.io/tokens

### 

    {
      "data": {
        "id": "e9cd1798-bd90-4984-8d0e-f5500d80bef2",
        "type": "token",
        "attributes": {
          "key": "UQ4sLxr1tXBX4c2e3GiG6Q2LzG7yMRuhi-LGDJqB0kJjXVtYKVyrTMyP2HtTyZpEuD71rvJy9Tn4SmHBtiimHg",
          "expires_at": 1554801857,
          "active": true
        }
      }
    }

### REFRESH TOKEN

    curl -H "Authorization: Token <TOKEN>"  -X POST  https://api.feedi.io/tokens/refresh
    
###
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
