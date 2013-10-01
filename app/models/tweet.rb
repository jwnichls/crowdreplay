class Tweet < ActiveRecord::Base
  attr_accessible :text, :created_at, :screenname, :user_id, :updated_at, :lang, :json
  has_and_belongs_to_many :tweet_categories
  
  def self.generate_csv(records, fields = Tweet.column_names, options = {})
    CSV.generate(options) do |csv|
      csv << fields.collect(&:humanize)
      records.each do |record|
        csv << record.attributes.values_at(*fields)
      end
    end
  end
end
