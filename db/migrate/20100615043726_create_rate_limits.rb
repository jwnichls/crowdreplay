class CreateRateLimits < ActiveRecord::Migration
  def self.up
    create_table :rate_limits do |t|
      t.integer :skipcount

      t.timestamps
    end
  end

  def self.down
    drop_table :rate_limits
  end
end
