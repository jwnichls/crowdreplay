class ChangeSizeOfIdForTweets < ActiveRecord::Migration
  def up
    change_column :tweets, :id, :integer, :limit => 8
  end

  def down
    change_column :tweets, :id, :integer
  end
end
