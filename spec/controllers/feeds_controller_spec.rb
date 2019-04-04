require 'rails_helper'

RSpec.describe FeedsController, type: :controller do
  let(:token) { create(:token) }

  describe "GET #index" do
    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(token.key)
      get :index
    end
    
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end
end
