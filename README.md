<a href="https://codeclimate.com/github/davidesantangelo/feedi/maintainability"><img src="https://api.codeclimate.com/v1/badges/e84db3d81a5e9935d63a/maintainability" /></a> <img src="https://img.shields.io/github/tag/davidesantangelo/feedi.svg"/> <a href="https://github.com/eonu/arx/blob/master/LICENSE"><img src="https://camo.githubusercontent.com/ad562cdf422b103f1a409db66ba31cb79414594d/68747470733a2f2f696d672e736869656c64732e696f2f6769746875622f6c6963656e73652f656f6e752f6172782e737667" alt="License" data-canonical-src="https://img.shields.io/github/license/eonu/arx.svg" style="max-width:100%;"></a> [![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/davidesantangelo/feedi/issues) [![Open Source Helpers](https://www.codetriage.com/davidesantangelo/feedi/badges/users.svg)](https://www.codetriage.com/davidesantangelo/feedi)
 <img src="https://img.shields.io/github/languages/top/davidesantangelo/feedi.svg"/>



# FEEDI

Feedi turns feed data into a fantastic API.

Feedi simplifies how you handle RSS, Atom, or JSON feeds. You can add and keep track of your favourite feed data with a simple and clean REST API. All entries are enriched by Machine Learning and Semantic engines.

## Search Engine

Take a look at [search.feedi.me](http://search.feedi.me) for a little search engine developed in React around this API. 

Feedback is welcome on [its repository](https://github.com/davidesantangelo/search.feedi.me).

## Built With

- [Ruby on Rails](https://github.com/rails/rails) &mdash; Our back end API is a Rails app. It responds to requests RESTfully in JSON.
- [PostgreSQL](https://www.postgresql.org/) &mdash; Our main data store is in Postgres.
- [Redis](https://redis.io/) &mdash; We use Redis as a cache and for transient data.
- [Feedjira](https://github.com/feedjira/feedjira) Feedjira is a Ruby library designed to parse feeds.
- [ElasticSearch](https://www.elastic.co/products/elasticsearch) Elasticsearch is a distributed, RESTful search and analytics engine.
- [Dandelion](https://dandelion.eu) Semantic Text Analytics as a service.
- [Sidekiq](http://sidekiq.org) Simple, efficient background processing for Ruby.
- [FastJSONAPI](https://github.com/Netflix/fast_jsonapi) A lightning fast JSON:API serializer for Ruby Objects.
- [Searchkick](https://github.com/ankane/searchkick) Intelligent search made easy.

Plus *lots* of Ruby Gems, a complete list of which is at [/master/Gemfile](https://github.com/davidesantangelo/feedi/blob/master/Gemfile).

## Buy me a coffee

If you want to support me in server costs to leave Feedi online, consider buying me a coffee! Thanks!

<a href="https://www.buymeacoffee.com/582rhJH" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>

## Routes

```ruby
       popular_feeds GET    /feeds/popular(.:format)                   feeds#popular
     tags_feed_entry GET    /feeds/:feed_id/entries/:id/tags(.:format) entries#tags
        feed_entries GET    /feeds/:feed_id/entries(.:format)          entries#index
          feed_entry GET    /feeds/:feed_id/entries/:id(.:format)      entries#show
           feed_logs GET    /feeds/:feed_id/logs(.:format)             logs#index
            feed_log GET    /feeds/:feed_id/logs/:id(.:format)         logs#show
       feed_webhooks GET    /feeds/:feed_id/webhooks(.:format)         webhooks#index
                     POST   /feeds/:feed_id/webhooks(.:format)         webhooks#create
        feed_webhook GET    /feeds/:feed_id/webhooks/:id(.:format)     webhooks#show
                     PATCH  /feeds/:feed_id/webhooks/:id(.:format)     webhooks#update
                     PUT    /feeds/:feed_id/webhooks/:id(.:format)     webhooks#update
                     DELETE /feeds/:feed_id/webhooks/:id(.:format)     webhooks#destroy
               feeds GET    /feeds(.:format)                           feeds#index
                     POST   /feeds(.:format)                           feeds#create
                feed GET    /feeds/:id(.:format)                       feeds#show
entries_search_index GET    /search/entries(.:format)                  search#entries
  feeds_search_index GET    /search/feeds(.:format)                    search#feeds
      current_tokens GET    /tokens/current(.:format)                  tokens#current
      refresh_tokens POST   /tokens/refresh(.:format)                  tokens#refresh
              tokens POST   /tokens(.:format)                          tokens#create
 ```
## Pagination

Requests that return multiple items will be paginated to 20 items by default. You can specify further pages with the ```?page``` parameter. Pagination information is available inside **headers**. Example:

```
Per-Page: 20
Link: <https://feedi.me/search/entries?q=<q>&page=1>; rel="first", <https://feedi.me/search/entries?q=<q>&page=2>; rel="next", <https://feedi.me/search/entries?q=<q>&page=24>; rel="last"
Total: 464
```

## Authentication

Feedi API uses OAuth 2.0 token for user authorization and API authentication. Applications must be authorized and authenticated before they can fetch data.

#### GET TOKEN ( expires in 2 hours )

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

#### RESPONSE ( get, refresh and current )
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

## Feeds

*RSS is a type of web feed which allows users and applications to access updates to online content in a standardized, computer-readable format* — [RSS Wiki](https://en.wikipedia.org/wiki/RSS).

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

## Entry

#### INDEX ENTRIES
    
    # GET /feeds/:id/entries

``` ruby
RestClient.get "https://feedi.me/feeds/:id/entries", { Authorization: "Token #{TOKEN}" }
```

```json
{
  "data": [
    {
      "id": "67a95338-d5d3-4a09-b805-03b9e13bcbd2",
      "type": "entry",
      "attributes": {
        "title": "The Real Stars of the Internet",
        "url": "https://www.nytimes.com/2019/04/19/style/star-ratings-amazon-uber-seamless.html?partner=rss&emc=rss",
        "published_at": 1555664402,
        "body": "The rater has become the rated.",
        "text": "The rater has become the rated.",
        "sentiment": {
          "type": "positive",
          "score": 0.6428571428571429
        }, 
        "categories": [
          "consumer reviews",
          "computers and the internet",
          "search engines",
          "delivery services",
          "brooklyn (nyc)",
          "your-feed-selfcare"
        ],
        "tags": []
      },
      "relationships": {
        "feed": {
          "data": {
            "id": "923d5997-ce13-41d4-98ca-8feb8513cdd4",
            "type": "feed"
          },
          "links": {
            "related": "http://www.rss.com/rss/homepage/rss2.0.xml"
          }
        }
      }
    },
    {
      "id": "87ab5dee-568f-460c-8ccc-5f13d418687c",
      "type": "entry",
      "attributes": {
        "title": "After Social Media Bans, Militant Groups Found Ways to Remain",
        "url": "https://www.nytimes.com/2019/04/19/technology/terrorist-groups-social-media.html?partner=rss&emc=rss",
        "published_at": 1555664407,
        "body": "Hezbollah and other groups classified as terrorist organizations by the United States have changed their social media strategies to stay on Facebook, YouTube and Twitter.",
        "text": "Hezbollah and other groups classified as terrorist organizations by the United States have changed their social media strategies to stay on Facebook, YouTube and Twitter.",
        "sentiment": {
          "type": "negative",
          "score": 0.7118571428441421
        }, 
        "categories": [
          "terrorism",
          "social media",
          "computers and the internet",
          "propaganda",
          "video recordings",
          "downloads and streaming",
          "muslims and islam",
          "hamas",
          "hezbollah",
          "facebook inc",
          "instagram inc",
          "twitter",
          "youtube.com"
        ],
        "tags": [
          "hezbollah",
          "terrorism",
          "organization",
          "united states",
          "social media",
          "facebook",
          "youtube",
          "twitter"
        ]
      },
      "relationships": {
        "feed": {
          "data": {
            "id": "923d5997-ce13-41d4-98ca-8feb8513cdd4",
            "type": "feed"
          },
          "links": {
            "related": "http://www.rss.it/rss/homepage/rss4.0.xml"
          }
        }
      }
    }
  ]
}
```

## Search (with elastic)

#### SEARCH ENTRIES

``` ruby
RestClient.get "https://feedi.me/search/entries?q={query}", { Authorization: "Token #{TOKEN}" }
```

#### SEARCH FEEDS

``` ruby
RestClient.get "https://feedi.me/search/feeds?q={query}", { Authorization: "Token #{TOKEN}" }
```

## Log

Every time a feed is imported, everything is logged into logs table.


#### INDEX LOGS

    # GET /feeds/:feed_id/logs

``` ruby
RestClient.get "https://feedi.me/feeds/:feed_id/logs", { Authorization: "Token #{TOKEN}" }
```

```json
{
  "data": [
    {
      "id": "f357678b-3ede-41e6-bb2f-56f258a83ce8",
      "type": "log",
      "attributes": {
        "start_import_at": "2019-04-17T14:54:15.183Z",
        "end_import_at": "2019-04-17T14:54:33.106Z",
        "entries_count": 52
      },
      "relationships": {
        "feed": {
          "data": {
            "id": "63bb067a-049a-4a20-815d-c903cd35ed32",
            "type": "feed"
          }
        }
      }
    },
    {
      "id": "b1b048ea-05da-4d51-a98b-0743ad772da8",
      "type": "log",
      "attributes": {
        "start_import_at": "2019-04-18T08:00:02.750Z",
        "end_import_at": "2019-04-18T08:00:13.625Z",
        "entries_count": 23
      },
      "relationships": {
        "feed": {
          "data": {
            "id": "63bb067a-049a-4a20-815d-c903cd35ed32",
            "type": "feed"
          }
        }
      }
    }
  ]
}
```

#### SHOW LOG

    # GET /feeds/:feed_id/logs/:id

``` ruby
RestClient.get "https://feedi.me/feeds/:feed_id/logs/:id", { Authorization: "Token #{TOKEN}" }
```

```json
{
  "data": {
    "id": "f357678b-3ede-41e6-bb2f-56f258a83ce8",
    "type": "log",
    "attributes": {
      "start_import_at": "2019-04-17T14:54:15.183Z",
      "end_import_at": "2019-04-17T14:54:33.106Z",
      "entries_count": 52
    },
    "relationships": {
      "feed": {
        "data": {
          "id": "63bb067a-049a-4a20-815d-c903cd35ed32",
          "type": "feed"
        }
      }
    }
  }
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davidesantangelo/feedi. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
