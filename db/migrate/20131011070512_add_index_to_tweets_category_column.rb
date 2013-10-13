class AddIndexToTweetsCategoryColumn < ActiveRecord::Migration
  def change
    add_index :tweets, :tweet_category_id
  end
end
