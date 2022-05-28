require 'rails_helper'

RSpec.describe HealthController, type: :request do
  describe "GET /index" do
    before do
      get "/health"
    end

    it "return status ok" do
      expect(last_response.status).to eq 200  
    end

    it "return message" do
      expect(json['message']).to eq "Server is running now"
    end
  end
end