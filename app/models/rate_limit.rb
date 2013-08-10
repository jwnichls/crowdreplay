class RateLimit < ActiveRecord::Base
  attr_accessible :skipcount, :created_at, :updated_at, :tweet_category_id
  belongs_to :tweet_category
end
