module Api
    class Api::V1::SearchTermsController < ApplicationController
        def create
            content = params[:content].to_s.strip

            return head :bad_request if content.blank?

            user_identifier = request.remote_ip

            # Fetching the last search term this IP has searched for
            last = SearchTerm.where(user_identifier: user_identifier)
                                .order(created_at: :desc)
                                .first

            # If no prior search or the current content doesn't start with the prior search term then we store the search term
            #
            # However, there's one drawback that this skips shorter queries. For example: this will log 'The Godfather 2' but 
            # skips 'The Godfather' if 'The Godfather 2' was logged first.
            #
            # We can favor longer queries by changing the condition to `!content.start_with?(last.content)`, but again we
            # will have the same drawback but reversed
            #
            # This is a trade-off for making a secure endpoint that doesn't allow pyramid problem if someone hit the endpoint
            # directly without going through the debouncer at the frontend
            #
            # We can minimize this effect by making a time-based decisions. For example, log the search term even if it the same
            # after 10 or 20 seconds, but the drawback will remain for this many seconds
            if last.nil? || !last.content.start_with?(content)
                SearchTerm.create!(
                    content: params[:content],
                    user_identifier: request.remote_ip
                )
            end

            head :ok
        end
    end
end