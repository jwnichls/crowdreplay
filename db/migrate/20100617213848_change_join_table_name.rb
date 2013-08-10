class ChangeJoinTableName < ActiveRecord::Migration
  def self.up
    drop_table :tweets_tweet_categories
    
    create_table :tweet_categories_tweets do |t|
      t.integer :tweet_id
      t.integer :tweet_category_id
    end
  end

  def self.down
    create_table :tweets_tweet_categories do |t|
      t.integer :tweet_id
      t.integer :tweet_category_id
    end

    drop_table :tweet_categories_tweets
  end
end
