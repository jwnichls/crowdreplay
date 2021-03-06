class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.integer :category_id
      t.datetime :start_time
      t.datetime :end_time
    end
  end

  def self.down
    drop_table :events
  end
end
