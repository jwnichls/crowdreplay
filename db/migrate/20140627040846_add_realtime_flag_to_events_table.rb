class AddRealtimeFlagToEventsTable < ActiveRecord::Migration
  def change
    add_column :events, :realtime, :boolean, :default => false, :null => false
  end
end
