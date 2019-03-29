require 'rails_helper'

RSpec.describe FeedsController, type: :controller do
  let(:token) { Token.create.key }

  describe "GET #index" do
    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(token)
      get :index
    end
    
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end
end
