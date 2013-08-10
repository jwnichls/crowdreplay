class IndexCategoryTweetsRelation < ActiveRecord::Migration
  def self.up
    add_index :tweet_categories_tweets, :tweet_id
    add_index :tweet_categories_tweets, :tweet_category_id
  end

  def self.down
    remove_index :tweet_categories_tweets, :tweet_id
    remove_index :tweet_categories_tweets, :tweet_category_id
  end
end
