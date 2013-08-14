class Recorder < ActiveRecord::Base
  attr_accessible :category, :oauth_access_secret, :oauth_access_token, :query, :running, :status, :screen_name
  
  def set_screenname
    if (self.screen_name == nil or self.screen_name == "") and self.oauth_access_token != nil and self.oauth_access_secret != nil
      twitter = Twitter::Client.new(
        :oauth_token => self.oauth_access_token,
        :oauth_token_secret => self.oauth_access_secret
      )
    
      self.screen_name = twitter.user.screen_name
    end
  end
end
