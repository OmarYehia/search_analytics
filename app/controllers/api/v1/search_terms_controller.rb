class Api::V1::SearchTermsController < ApplicationController
    def create
        content = params[:content].to_s.strip

        return head :bad_request if content.blank?

        user_identifier = request.remote_ip
        
        current_search = SearchTerm.create!(
            content: content,
            user_identifier: user_identifier
        )

        cleanup_incomplete_searches(user_identifier, content)


        head :ok
    end

    def clear
        SearchTerm.delete_all
        render json: { message: 'All search logs cleared successfully.' }, status: :ok
    end

    def cleanup_incomplete_searches(user_identifier, final_content)
        recent_searches = SearchTerm
          .where(user_identifier: user_identifier)
          .where('created_at >= ?', 2.minutes.ago)
          .where.not(content: final_content)
          .order(created_at: :desc)
    
        searches_to_remove = recent_searches.select do |search|
          search_content = search.content.strip.downcase
          final_content_lower = final_content.strip.downcase
          
          final_content_lower.start_with?(search_content) && 
          search_content.length < final_content_lower.length
        end
    
        if searches_to_remove.any?
          SearchTerm.where(id: searches_to_remove.map(&:id)).delete_all
        end
    end
end
