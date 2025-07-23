class SearchTerm < ApplicationRecord
    validates :content, presence: true
    validates :user_identifier, presence: true

    # Might create a feature later if time allowed to show latest trends over the last 24 hours
    scope :recent, -> { where('created_at >= ?', 24.hours.ago) }
end
