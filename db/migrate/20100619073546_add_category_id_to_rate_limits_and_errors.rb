class AddCategoryIdToRateLimitsAndErrors < ActiveRecord::Migration
  def self.up
    add_column :rate_limits, :tweet_category_id, :integer
    add_column :tweet_errors, :tweet_category_id, :integer
    
    add_index :rate_limits, :tweet_category_id
    add_index :rate_limits, :created_at
  end

  def self.down
    remove_column :rate_limits, :tweet_category_id
    remove_column :tweet_errors, :tweet_category_id
    
    remove_index :rate_limits, :tweet_category_id
    remove_index :rate_limits, :created_at
  end
end
