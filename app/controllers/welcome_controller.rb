class WelcomeController < BaseController
  skip_before_action :require_authentication

  def index
    response =
      {
        "name":"Feedi API",
        "version":"0.1",
        "github_repo_url":"https://github.com/davidesantangelo/feedi-backend",
        "author":"Davide Santangelo"
      }

    render json: response
  end
end
