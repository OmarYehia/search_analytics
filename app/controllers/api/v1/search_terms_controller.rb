class Api::V1::SearchTermsController < ApplicationController
    def create
        content = params[:content].to_s.strip

        return head :bad_request if content.blank?

        user_identifier = request.remote_ip
        should_log = true

        # Fetching the last search term this IP has searched for
        last = SearchTerm
            .where(user_identifier: user_identifier)
            .where('created_at >= ?', 1.minutes.ago) # Some people write slower than the debounce
            .order(created_at: :desc)
            .first

        # ================= Old thoughts, didn't want to delete to share my thought process =================
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
        # ===================================================================================================

        if last
            last_content = last.content.strip
            time_diff = Time.current - last.created_at

            # Skip logging if
            # 1. Very recent (< 5 seconds)
            # 2. Very similar (relationship between last content and current content in both directions -adding or removing characters-)
            # 3. Not too different in length
            if time_diff < 5.seconds
                current_lower = content.downcase
                last_lower = last_content.downcase

                length_diff = (content.length - last_content.length).abs

                if (current_lower.start_with?(last_lower) || last_lower.start_with?(current_lower)) && length_diff < 10
                    should_log = false
                end
            end

            # Log duplicate content after 15 seconds. The user might be retrying
            if content.downcase  == last_content.downcase && time_diff >= 15.seconds
                should_log = true
            end
        end

        if should_log
            SearchTerm.create!(
                content: params[:content],
                user_identifier: request.remote_ip
            )
        end

        head :ok
    end
end
