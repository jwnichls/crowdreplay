class TweetCategory < ActiveRecord::Base
  attr_accessible :category, :created_at, :updated_at
  has_many :tweets
  has_many :tweet_volumes
  has_many :rate_limits
  has_many :tweet_errors
  has_and_belongs_to_many :events
end
