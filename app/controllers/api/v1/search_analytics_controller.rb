class Api::V1::SearchAnalyticsController < ApplicationController
    # Was used for testing
    def index
        top_queries_overall = SearchTerm
            .group(:content)
            .order('count_all DESC')
            .limit(10)
            .count

        top_per_user = SearchTerm
            .group(:user_identifier, :content)
            .order('count_all DESC')
            .count

        render json: {
            top_queries: top_queries_overall,
            top_per_user: top_per_user,
        }
    end

    def top_terms
        terms = SearchTerm
        .group(:content)
        .order('count_all DESC')
        .limit(10)
        .count
    
        render json: terms
    end
  
    def trends
        data = SearchTerm
        .group_by_day(:created_at, last: 7)
        .count
    
        render json: data
    end
    
    def user_activity
        data = SearchTerm
        .group(:user_identifier)
        .order('count_all DESC')
        .limit(10)
        .count
    
        render json: data
    end
end