class User < ActiveRecord::Base
    acts_as_authentic do |c|
    # authlogic config options go here
    c.login_field = 'email'
  end
  
  attr_accessible :email, :password, :password_confirmation
  
  validates :email, :presence => true
  
  def admin?
    self.admin
  end
end
