class MakeTheCategoryColumnHaveTheRightNameDumbass < ActiveRecord::Migration
  def self.up
    remove_column :tweet_volumes, :category_id
    add_column :tweet_volumes, :tweet_category_id, :integer
  end

  def self.down
    remove_column :tweet_volumes, :tweet_category_id
    add_column :tweet_volumes, :category_id, :integer
  end
end
