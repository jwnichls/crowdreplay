class CreateCategoriesEventsJoinTable < ActiveRecord::Migration
  def change
    create_table :events_tweet_categories, :id => false do |t|
      t.integer :event_id
      t.integer :tweet_category_id
    end
  end
end
