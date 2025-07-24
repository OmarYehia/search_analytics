require 'rails_helper'

RSpec.describe "SearchAnalytics API", type: :request do
    describe "POST /api/v1/search_terms" do
      it "logs a new search term" do
        post "/api/v1/search_terms", params: { content: "Godfather" }.to_json,
             headers: { "CONTENT_TYPE" => "application/json" }
  
        expect(response).to have_http_status(:ok)
        expect(SearchTerm.last.content).to eq("Godfather")
      end
    end
  
    describe "GET analytics endpoints" do
      before do
        SearchTerm.create!(content: "Godfather", user_identifier: 'foo')
        SearchTerm.create!(content: "Batman", user_identifier: 'foo')
      end
  
      it "returns top terms" do
        get "/api/v1/search_analytics/top_terms"
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to be_a(Hash)
      end
  
      it "returns user activity" do
        get "/api/v1/search_analytics/user_activity"
        expect(response).to have_http_status(:ok)
      end
  
      it "returns search trends" do
        get "/api/v1/search_analytics/trends"
        expect(response).to have_http_status(:ok)
      end
    end
end