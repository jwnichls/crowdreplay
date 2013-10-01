class Tweet < ActiveRecord::Base
  attr_accessible :text, :created_at, :screenname, :user_id, :updated_at, :lang, :json
  has_and_belongs_to_many :tweet_categories
  
  # From:
  # http://railscasts.com/episodes/362-exporting-csv-and-excel?view=comments
  
  def self.generate_csv(records, fields = Tweet.column_names, options = {})
    CSV.generate(options) do |csv|
      csv << fields.collect(&:humanize)
      records.each do |record|
        csv << record.attributes.values_at(*fields)
      end
    end
  end
  
  # From:
  # http://smsohan.com/blog/2013/05/09/genereating-and-streaming-potentially-large-csv-files-using-ruby-on-rails/
  def self.csv_header(fields = Tweet.column_names)
    #Using ruby's built-in CSV::Row class
    #true - means its a header
    CSV::Row.new(fields, fields.collect(&:humanize), true)
  end

  def to_csv_row(fields = Tweet.column_names)
    CSV::Row.new(fields, self.attributes.values_at(*fields))
  end

end
