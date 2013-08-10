class TweetError < ActiveRecord::Base
  attr_accessible :message, :created_at, :updated_at, :tweet_category_id
  belongs_to :tweet_category
end
