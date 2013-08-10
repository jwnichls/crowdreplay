class TweetVolume < ActiveRecord::Base
  attr_accessible :time, :count, :tweet_category_id
  belongs_to :tweet_category
end
