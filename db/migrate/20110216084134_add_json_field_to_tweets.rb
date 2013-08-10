class AddJsonFieldToTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :json, :text, :limit => 5000
  end

  def self.down
    remove_column :tweets, :json
  end
end
