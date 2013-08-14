class AddScreennameToRecordersTable < ActiveRecord::Migration
  def change
    add_column :recorders, :screen_name, :string
  end
end
