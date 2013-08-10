class Recorder < ActiveRecord::Base
  attr_accessible :category, :oauth_access_secret, :oauth_access_token, :query, :running, :status
end
