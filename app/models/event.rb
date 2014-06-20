class Event < ActiveRecord::Base
  attr_accessible :name, :category_id, :start_time, :end_time
  
  def category
    TweetCategory.find(self.category_id)
  end
end
