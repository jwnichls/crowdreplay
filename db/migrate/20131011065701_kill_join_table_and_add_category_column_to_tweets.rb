class KillJoinTableAndAddCategoryColumnToTweets < ActiveRecord::Migration
  def up
    add_column :tweets, :tweet_category_id, :integer
  end

  def down
    remove_column :tweets, :tweet_category_id
  end
end
