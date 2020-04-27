# frozen_string_literal: true

class WelcomeController < BaseController
  skip_before_action :require_authentication

  def index
    response =
      {
        "name": 'FeediRSS',
        "description": 'RSS as RESTful. This service allows you to transform RSS feed into an awesome API.',
        "version": '0.6',
        "github_repo_url": 'https://github.com/davidesantangelo/feedirss-api',
        "author": {
          "name": 'Davide Santangelo',
          "website": 'https://www.davidesantangelo.com'
        }
      }

    render json: response
  end
end
