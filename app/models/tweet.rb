class Tweet < ActiveRecord::Base
  attr_accessible :text, :created_at, :screenname, :user_id, :updated_at, :lang, :json
  belongs_to :tweet_categories
  
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

  def self.clear_table_name_suffix
    if self.table_name_suffix and self.table_name_suffix != ""
      self.table_name = table_name[0,self.table_name.length-self.table_name_suffix.length]
      self.table_name_suffix = ""
    end
  end

  def self.use_category(category)
    self.table_name
    
    if self.table_name_suffix and self.table_name_suffix.length > 0
      self.clear_table_name_suffix
    end
    
    if category
      self.table_name_suffix = "_" + category.id.to_s
      old_table_name = self.table_name
      self.table_name = self.table_name.to_s + self.table_name_suffix.to_s
      
      if !ActiveRecord::Base.connection.table_exists?(self.table_name)
        puts "Create table here " + self.table_name + " like " + old_table_name
        ActiveRecord::Base.connection.execute("create table #{self.quoted_table_name} like `#{old_table_name}`")
      end
    end
  end
end
