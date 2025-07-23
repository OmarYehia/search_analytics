class Api::V1::SearchTermsController < ApplicationController
    def create
        SearchTerm.create!(
            content: params[:content],
            user_identifier: request.remote_ip
        )

        head :ok
    end
end
