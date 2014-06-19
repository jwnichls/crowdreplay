class GameViewController < ApplicationController
  def index
    @recorders = Recorder.find_all_by_running(true)
    @events = Event.find(:all, :order => :start_time)
  end
  
  def show
    if !params[:eventid].nil?
      @event = Event.find_by_id(params[:eventid])
      
      @category = TweetCategory.find_by_id(@event.category_id)
      Tweet.use_category(@category)
      
      @starttime = @event.start_time
      @endtime = @event.end_time
    else 
      @event = Event.new

      if params[:category].nil?
        @category = TweetCategory.find_by_id(1)
      else
        @category = TweetCategory.find_by_category(params[:category])
      end
      
      Tweet.use_category(@category)

      @endtime = 2.minutes.ago.utc.change(:sec => 0)
      @starttime = 122.minutes.ago.utc.change(:sec => 0)

      if !params[:starttime].nil?
        @starttime = DateTime.parse(params[:starttime]).utc
      end

      if !params[:endtime].nil?
        @endtime = DateTime.parse(params[:endtime]).utc
      end

      @event.category_id = @category.id
      @event.start_time = @starttime
      @event.end_time = @endtime
    end
  end
  
  def d3test
    if params[:category].nil?
      @category = TweetCategory.find_by_id(1)
    else
      @category = TweetCategory.find_by_category(params[:category])
    end
    
    Tweet.use_category(@category)

    @endtime = 2.minutes.ago.utc.change(:sec => 0)
    @starttime = 122.minutes.ago.utc.change(:sec => 0)

    if !params[:starttime].nil?
      @starttime = DateTime.parse(params[:starttime]).utc
    end

    if !params[:endtime].nil?
      @endtime = DateTime.parse(params[:endtime]).utc
    end
  end

  def data
    if !params[:eventid].nil?
      @event = Event.find_by_id(params[:eventid])
      
      @category = TweetCategory.find_by_id(@event.category_id)
      Tweet.use_category(@category)
      @starttime = @event.start_time
      @endtime = @event.end_time
    else 
      @event = Event.new

      if params[:category].nil?
        @category = TweetCategory.find_by_id(1)
      else
        @category = TweetCategory.find_by_category(params[:category])
      end
      Tweet.use_category(@category)

      @endtime = 2.minutes.ago.utc.change(:sec => 0)
      @starttime = 122.minutes.ago.utc.change(:sec => 0)

      if !params[:starttime].nil?
        @starttime = DateTime.parse(params[:starttime]).utc
      end

      if !params[:endtime].nil?
        @endtime = DateTime.parse(params[:endtime]).utc
      end

      @event.category_id = @category.id
      @event.start_time = @starttime
      @event.end_time = @endtime
    end
    
    @volumes = calculate_and_cache_volumes(@category,@starttime,@endtime)
    @max = @volumes.max_by(&:count).count + 10
    
    render layout: nil
  end

  def realtime
    if params[:category].nil?
      @category = TweetCategory.find_by_id(1)
    else
      @category = TweetCategory.find_by_category(params[:category])
    end
    Tweet.use_category(@category)
  end

  def tweets_at_time
    @category = TweetCategory.find_by_category(params[:category]) 
    Tweet.use_category(@category)

    filters = nil

    if !params[:time].nil?
      @time = DateTime.parse(params[:time]).utc

      if !params[:endtime].nil?
        @endtime = DateTime.parse(params[:endtime]).utc
      else
        @endtime = @time.advance(:minutes => 1)
      end

      filters = ["created_at >= ? AND created_at < ? AND lang = ?", @time, @endtime, "en"]
    end

    if params[:format] != "csv"
      @tweets = @category.tweets.where(filters)
    end
    
    respond_to do |format|
      format.html { render layout: nil }
      format.csv { render_csv(["id", "screenname", "user_id", "text", "created_at"], filters) }
    end
  end
  
  private
  
  def calculate_and_cache_volumes(category, starttime, endtime)
    
    starttime = starttime.change(:sec => 0)
    endtime = endtime.change(:sec => 0)   
    difference = (endtime.to_i - starttime.to_i) / 60

    volumes = category.tweet_volumes.find(:all, :conditions => ["time >= ? AND time <= ?", starttime, endtime])
    
    timecounter = starttime.clone
    volcounter = 0
    0.upto(difference) { |m| 
	
      nexttime = timecounter.advance(:minutes => 1)

      while volcounter < volumes.length and volumes[volcounter].time < timecounter
        # somehow we ended up with more than one measurement at a time we already considered
        volumes.delete_at(volcounter)        
      end

	    if volcounter >= volumes.length or volumes[volcounter].time > timecounter
        vol = TweetVolume.new
        vol.time = timecounter
        vol.tweet_category_id = category.id
        vol.count = 0
        
        volumes.insert(volcounter, vol)
      end
      
	    volcounter = volcounter + 1
      timecounter = nexttime
    }
    
    return volumes
  end
  
  def assemble_two_volume_array(vol1, vol2)
    volumes = []
    vol1.each_with_index do |volitem, index|
      volumes.push({:time => vol1[index].time, :count1 => vol1[index].count, :count2 => vol2[index].count})
    end
    
    return volumes
  end
  
  # CSV Stuff from:
  # http://smsohan.com/blog/2013/05/09/genereating-and-streaming-potentially-large-csv-files-using-ruby-on-rails/
  def render_csv(fields, filters)
    set_file_headers
    set_streaming_headers

    response.status = 200

    #setting the body to an enumerator, rails will iterate this enumerator
    self.response_body = csv_lines(fields, filters)
  end

  def set_file_headers
    file_name = @category.category + ".csv"
    headers["Content-Type"] = "text/csv"
    headers["Content-disposition"] = "attachment; filename=\"#{file_name}\""
  end

  def set_streaming_headers
    #nginx doc: Setting this to "no" will allow unbuffered responses suitable for Comet and HTTP streaming applications
    headers['X-Accel-Buffering'] = 'no'

    headers["Cache-Control"] ||= "no-cache"
    headers.delete("Content-Length")
  end

  def csv_lines(fields, filters)

    Enumerator.new do |y|
      y << Tweet.csv_header(fields).to_s

      #ideally you'd validate the params, skipping here for brevity
      @category.tweets.where(filters).find_each(batch_size: 200) do |tweet|
        y << tweet.to_csv_row(fields).to_s
      end
    end
  end
end
