class CreateTweetErrors < ActiveRecord::Migration
  def self.up
    create_table :tweet_errors do |t|
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :tweet_errors
  end
end
