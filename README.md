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

```json
{
  "data": [
    {
      "id": "27c3f611-48e4-41fa-b0bb-c89bdda2db83",
      "type": "feed",
      "attributes": {
        "title": "Apple Newsroom",
        "description": "",
        "url": "feed:https://www.apple.com/newsroom/rss-feed.rss",
        "status": "enabled",
        "entries_count": 20,
        "last_import_at": 1555675203
      }
    },
    {
      "id": "923d5997-ce13-41d4-98ca-8feb8513cdd4",
      "type": "feed",
      "attributes": {
        "title": "NYT > Technology",
        "description": "",
        "url": "http://feeds.nytimes.com/nyt/rss/Technology",
        "status": "enabled",
        "entries_count": 40,
        "last_import_at": 1555675203
      }
    }
  ]
}
```

#### SHOW FEED
    
    # GET /feeds/:id

``` ruby
RestClient.get "https://feedi.me/feeds/{id}", { Authorization: "Token #{TOKEN}" }
```

#### CREATE FEED
    
    # POST /feeds
    
``` ruby
payload = { url: "http://www.repubblica.it/rss/homepage/rss2.0.xml" }.to_json

headers = { Authorization: "Token #{TOKEN}", content_type: :json, accept: :json }

RestClient.post("https://feedi.me/feeds", payload, headers)
```

#### POPULAR FEEDS
    
    # GET /feeds/popular

``` ruby
RestClient.get "https://feedi.me/feeds/popular", { Authorization: "Token #{TOKEN}" }
```

### ENTRY

#### INDEX ENTRIES

#### INDEX FEEDS
    
    # GET /feeds/:id/entries

``` ruby
RestClient.get "https://feedi.me/feeds/:id/entries", { Authorization: "Token #{TOKEN}" }
```

```json
{
  "data": [
    {
      "id": "597b3b5a-f02a-4cd0-acfa-ac4d2d6e9abc",
      "type": "entry",
      "attributes": {
        "title": "L’intelligenza artificiale come cambierà le nostre vite? La versione di Floridi",
        "url": "https://corriereinnovazione.corriere.it/2019/04/18/intelligenza-artificiale-come-cambiera-nostre-vite-versione-floridi-ae636c64-61c6-11e9-bdff-f123a121117e.shtml",
        "published_at": 1555593506,
        "body": "Il docente di Filosofia ed Etica dell'informazione ad Oxford alla Colazione Digitale di Sorgenia: «il rischio è di crescere una generazione di pigri»",
        "text": "Il docente di Filosofia ed Etica dell'informazione ad Oxford alla Colazione Digitale di Sorgenia: «il rischio è di crescere una generazione di pigri»",
        "categories": [
          "news"
        ],
        "tags": [
          "filosofia",
          "etica",
          "informazione",
          "oxford",
          "sorgenia"
        ]
      },
      "relationships": {
        "feed": {
          "data": {
            "id": "91a333f3-37a1-497f-b34c-b0c99c9d35c1",
            "type": "feed"
          }
        }
      }
    },
    {
      "id": "d5c8b047-8f5c-45c8-949a-07e05edc2705",
      "type": "entry",
      "attributes": {
        "title": "Lo Stato investitore e la tentazionedel fondo Iri-tech",
        "url": "https://corriereinnovazione.corriere.it/2019/03/06/stato-investitore-tentazione-392921d6-401b-11e9-bb83-aca868a1eb53.shtml",
        "published_at": 1551886263,
        "body": "Il piano del governo per finanziarie con un miliardo di euro il mondo delle start up  crea forti aspettative. Ma deve far parte di una visione più ampia dell’innovazione che  parte dall’istruzione, dalla formazione e dalla scienza  ",
        "text": "Il piano del governo per finanziarie con un miliardo di euro il mondo delle start up  crea forti aspettative. Ma deve far parte di una visione più ampia dell’innovazione che  parte dall’istruzione, dalla formazione e dalla scienza",
        "categories": [
          "news"
        ],
        "tags": []
      },
      "relationships": {
        "feed": {
          "data": {
            "id": "91a333f3-37a1-497f-b34c-b0c99c9d35c1",
            "type": "feed"
          }
        }
      }
    }
  ]
}
```
