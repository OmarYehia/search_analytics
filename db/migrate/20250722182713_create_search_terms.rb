class CreateSearchTerms < ActiveRecord::Migration[8.0]
  def change
    create_table :search_terms do |t|
      t.string :content
      t.string :user_identifier

      t.timestamps
    end
  end
end
