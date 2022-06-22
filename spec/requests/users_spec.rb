require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "get /show" do
    it 'test user is present' do
      user = User.create(name: 'First', email: 'sample@example.com', web_url: 'https://www.google.com/', password: 'test@123')
      get user_url(user.id)
      expect(response).to have_http_status(200)
    end
  end
end
