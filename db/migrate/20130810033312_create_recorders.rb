class CreateRecorders < ActiveRecord::Migration
  def change
    create_table :recorders do |t|
      t.string :category
      t.string :query
      t.string :oauth_access_token
      t.string :oauth_access_secret
      t.string :status
      t.boolean :running

      t.timestamps
    end
  end
end
