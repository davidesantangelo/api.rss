<a href="https://codeclimate.com/github/davidesantangelo/feedi/maintainability"><img src="https://api.codeclimate.com/v1/badges/e84db3d81a5e9935d63a/maintainability" /></a> <img src="https://img.shields.io/github/tag/davidesantangelo/feedi.svg"/> <a href="https://github.com/eonu/arx/blob/master/LICENSE"><img src="https://camo.githubusercontent.com/ad562cdf422b103f1a409db66ba31cb79414594d/68747470733a2f2f696d672e736869656c64732e696f2f6769746875622f6c6963656e73652f656f6e752f6172782e737667" alt="License" data-canonical-src="https://img.shields.io/github/license/eonu/arx.svg" style="max-width:100%;"></a> [![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/davidesantangelo/feedi/issues) [![Open Source Helpers](https://www.codetriage.com/davidesantangelo/feedi/badges/users.svg)](https://www.codetriage.com/davidesantangelo/feedi)
 <img src="https://img.shields.io/github/languages/top/davidesantangelo/feedi.svg"/>



# FeediRSS

Feedi turns feed data into a fantastic API.

Feedi simplifies how you handle RSS, Atom, or JSON feeds. You can add and keep track of your favourite feed data with a simple and clean REST API. All entries are enriched by Machine Learning and Semantic engines.

## Search Engine

Take a look at a little search engine developed in React around this API. 

www.datorss.com

Feedback is welcome on [its repository](https://github.com/davidesantangelo/datorss).


## Example

``` json

GET https://api.feedirss.com/search/entries?q=rails

{
  "data": [
    {
      "id": "9237e923-db08-4070-8952-719a796f911a",
      "type": "entry",
      "attributes": {
        "title": "larrycameron80 forked larrycameron80/datorss from davidesantangelo/datorss",
        "url": "https://github.com/larrycameron80/datorss",
        "published_at": 1586916098,
        "body": null,
        "text": "larrycameron80 forked larrycameron80/datorss from davidesantangelo/datorss",
        "categories": [],
        "sentiment": {
          "type": "neutral",
          "score": 0.0
        },
        "parent": {
          "id": "7bebbfa1-2aab-4078-b137-467c65a8ea11",
          "title": "Private Feed for davidesantangelo",
          "url": "feed:https://github.com/davidesantangelo.private.atom?token=AAIZRI6MMQ2CHEVULORFWUV237TOA",
          "rank": 99.0
        },
        "tags": []
      },
      "relationships": {
        "feed": {
          "data": {
            "id": "7bebbfa1-2aab-4078-b137-467c65a8ea11",
            "type": "feed"
          }
        }
      }
    },
  ]
}

```


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

## Schema

All API access is over HTTPS, and accessed from https://api.feedirss.com. All data is sent and received as JSON.


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

## WIKI

https://github.com/davidesantangelo/feedirss-api/wiki

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davidesantangelo/feedirss-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
