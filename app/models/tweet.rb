class Tweet < ActiveRecord::Base
  attr_accessible :text, :created_at, :screenname, :user_id, :updated_at, :lang, :json
  has_and_belongs_to_many :tweet_categories
end
