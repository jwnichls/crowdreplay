class User < ActiveRecord::Base
  acts_as_authentic 
  # do |c|
  #   Configuration Options (if needed) will go here
  # end 
end
