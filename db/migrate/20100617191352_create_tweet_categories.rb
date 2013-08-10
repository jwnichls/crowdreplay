class CreateTweetCategories < ActiveRecord::Migration
  def self.up
    create_table :tweet_categories do |t|
      t.string :category

      t.timestamps
    end

    create_table :tweets_tweet_categories do |t|
      t.integer :tweet_id
      t.integer :tweet_category_id
    end
  end

  def self.down
    drop_table :tweet_categories
    drop_table :tweets_tweet_categories
  end
end
