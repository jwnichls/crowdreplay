class AddTweetCategoryJoinTable < ActiveRecord::Migration
  def self.up    
    add_column :tweets, :lang, :string
  end

  def self.down
    remove_column :tweets, :lang
  end
end
