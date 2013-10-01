class GameViewController < ApplicationController
  def show
    if !params[:eventid].nil?
      @event = Event.find_by_id(params[:eventid])
      
      @category = TweetCategory.find_by_id(@event.category_id)
      @starttime = @event.start_time
      @endtime = @event.end_time
    else 
      @event = Event.new

      if params[:category].nil?
        @category = TweetCategory.find_by_id(1)
      else
        @category = TweetCategory.find_by_category(params[:category])
      end

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

  def graphdata
    if !params[:eventid].nil?
      @event = Event.find_by_id(params[:eventid])
      
      @category = TweetCategory.find_by_id(@event.category_id)
      @starttime = @event.start_time
      @endtime = @event.end_time
    else 
      @event = Event.new

      if params[:category].nil?
        @category = TweetCategory.find_by_id(1)
      else
        @category = TweetCategory.find_by_category(params[:category])
      end

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
    
    calculate_and_cache_volumes(@category,@starttime,@endtime)

    @volumes = @category.tweet_volumes.find(:all, :conditions => ["time >= ? AND time <= ?", @starttime, @endtime])
    @max = @category.tweet_volumes.maximum(:count, :conditions => ["time >= ? AND time <= ?", @starttime, @endtime]) + 10
    
    render layout: nil
  end

  def realtime
    if params[:category].nil?
      @category = TweetCategory.find_by_id(1)
    else
      @category = TweetCategory.find_by_category(params[:category])
    end
  end

  def tweets_at_time
    @category = TweetCategory.find_by_category(params[:category]) 

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
    
    recorder = Recorder.find_by_category(category.category)
    starttime = starttime.change(:sec => 0)
    endtime = endtime.change(:sec => 0)   
    difference = (endtime.to_i - starttime.to_i) / 60

    timecounter = starttime.clone
    0.upto(difference) { |m| 
	
      nexttime = timecounter.advance(:minutes => 1)
      vol = category.tweet_volumes.find_by_time(timecounter)

      # logger.info("vol.time=#{vol.time}") unless vol.nil?
      
      if vol.nil?
        #logger.info("timecounter=#{timecounter}")
      	#logger.info("nexttime=#{nexttime}")

        # count = category.tweets.find(:all, :conditions => ["tweets.created_at >= ? AND tweets.created_at < ?", timecounter, nexttime]).count
        count = Tweet.count(:joins => "inner join tweet_categories_tweets on tweets.id = tweet_categories_tweets.tweet_id",
                            :conditions => ["tweets.created_at >= ? AND tweets.created_at < ? AND tweet_categories_tweets.tweet_category_id = ?", timecounter, nexttime, category.id])
        #logger.info("count=#{count}")
        count += category.rate_limits.sum(:skipcount, :conditions => ["rate_limits.created_at >= ? AND rate_limits.created_at < ?", timecounter, nexttime])
        
        #if count <= 0
        #  count = Math.log10(count).round
        #end
        
        vol = category.tweet_volumes.create(:time => timecounter, :count => count)
        vol.save
      elsif recorder && recorder.running
        # don't calculate our own volumes at the end of the recording phase if the recorder is running
        return
      end
      
      timecounter = nexttime
    }    
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
