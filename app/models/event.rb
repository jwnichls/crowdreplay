class Event < ActiveRecord::Base
  attr_accessible :name, :category_id, :start_time, :end_time
end
