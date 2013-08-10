class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.string :text
      t.datetime :created_at
      t.string :screenname
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end
