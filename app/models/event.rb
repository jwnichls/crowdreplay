class Event < ActiveRecord::Base
  has_and_belongs_to_many :tweet_categories
  attr_accessible :name, :start_time, :end_time, :realtime
  
  def add_categories(category_names)
    category_names = category_names.split(",")
    category_names.each { |category_name| 
    
      category = TweetCategory.find_by_category(category_name)
      if category and !self.tweet_categories.include?(category)
        self.tweet_categories << category
      end
    }
  end
  
  def link_hash
    if self.realtime
      if self.start_time
        {:controller => :game_view, :action => :realtime, :categories => self.category_names, :starttime => self.start_time}
      else
        {:controller => :game_view, :action => :realtime, :categories => self.category_names}
      end
    else
      if self.start_time and self.end_time
        {:controller => :game_view, :action => :show, :categories => self.category_names, :starttime => self.start_time, :endtime => self.end_time}
      elsif self.start_time
        {:controller => :game_view, :action => :show, :categories => self.category_names, :starttime => self.start_time}
      else
        {:controller => :game_view, :action => :show, :categories => self.category_names}
      end
    end
  end
  
  def category_names
    str = self.tweet_categories[0].category
    if self.tweet_categories.length > 1
      self.tweet_categories[1..(self.tweet_categories.length-1)].each { |c| 
        str += "," + c.category
      }
    end
    str
  end
end
