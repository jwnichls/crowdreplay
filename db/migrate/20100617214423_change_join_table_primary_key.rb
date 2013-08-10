class ChangeJoinTablePrimaryKey < ActiveRecord::Migration
  def self.up
    drop_table :tweet_categories_tweets
    
    create_table :tweet_categories_tweets, :id => false do |t|
      t.integer :tweet_id
      t.integer :tweet_category_id
    end
  end

  def self.down
    drop_table :tweet_categories_tweets
    
    create_table :tweet_categories_tweets do |t|
      t.integer :tweet_id
      t.integer :tweet_category_id
    end
  end
end
