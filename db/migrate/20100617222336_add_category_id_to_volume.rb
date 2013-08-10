class AddCategoryIdToVolume < ActiveRecord::Migration
  def self.up
    add_column :tweet_volumes, :category_id, :integer
  end

  def self.down
    remove_column :tweet_volumes, :category_id
  end
end
