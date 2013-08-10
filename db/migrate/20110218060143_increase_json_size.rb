class IncreaseJsonSize < ActiveRecord::Migration
  def self.up
    change_column :tweets, :json, :string, :limit => 7500
  end

  def self.down
    change_column :tweets, :json, :string, :limit => 5000
  end
end
