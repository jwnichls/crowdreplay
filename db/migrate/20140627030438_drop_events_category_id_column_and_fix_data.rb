class DropEventsCategoryIdColumnAndFixData < ActiveRecord::Migration
  def up
    # insert the categories from the events into the new schema
    Event.find(:all).each { |e| c = TweetCategory.find(e.category_id); e.tweet_categories << c; }
    
    # drop the column we no longer care about
    remove_column :events, :category_id
  end

  def down
    # add the column back
    add_column :events, :category_id
    
    # populate the column
    Event.reset_column_information
    Event.find(:all).each { |e| c = e.categories[0]; e.category_id = c.id; e.save; }
  end
end
