class CreateTweetVolumes < ActiveRecord::Migration
  def self.up
    create_table :tweet_volumes do |t|
      t.datetime :time
      t.integer :count
    end
  end

  def self.down
    drop_table :tweet_volumes
  end
end
