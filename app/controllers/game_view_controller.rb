class GameViewController < ApplicationController 
  
  def index
    @recorders = Recorder.find_all_by_running(true)
    @events = Event.find_all_by_realtime(false, :order => "start_time DESC")
    @current = Event.find_all_by_realtime(true)
  end
  
  def show
    @categories = []
    @events = []
    
    if !params[:events].nil?
      event_names = params[:events].split(",")
      
      event_names.each { |event_name| 
        
        event = Event.find_by_name(event_name)
        if !event
          @events.push(event)
          @categories.pust(event.category)

          @starttime = earliest_date(@starttime, event.start_time)
          @endtime = latest_date(@endtime, event.end_time)
        end          
      }
      
    elsif !params[:categories].nil?

      category_names = params[:categories].split(",")
      category_names.each { |category_name| 
      
        category = TweetCategory.find_by_category(category_name)
        if category
          @categories.push(category)
        end
      }

      @endtime = 2.minutes.ago.utc.change(:sec => 0)
      @starttime = 122.minutes.ago.utc.change(:sec => 0)

      if !params[:starttime].nil?
        @starttime = DateTime.parse(params[:starttime]).utc
      end

      if !params[:endtime].nil?
        @endtime = DateTime.parse(params[:endtime]).utc
      end

      @event = Event.new
      @event.start_time = @starttime
      @event.end_time = @endtime
    end    
  end

  def data
    @categories = []
    if !params[:categories].nil?
      category_names = params[:categories].split(",")
      category_names.each { |category_name| 
      
        category = TweetCategory.find_by_category(category_name)
        if category
          @categories.push(category)
        end
      }
    end

    @endtime = 2.minutes.ago.utc.change(:sec => 0)
    @starttime = 122.minutes.ago.utc.change(:sec => 0)

    if !params[:starttime].nil?
      @starttime = DateTime.parse(params[:starttime]).utc
    elsif !params[:since].nil?
      @starttime = DateTime.parse(params[:since]).utc + 60 # return a minute after since
    end

    if !params[:endtime].nil?
      @endtime = DateTime.parse(params[:endtime]).utc
    end
    
    @volumes = get_volumes(@categories,@starttime,@endtime)
    
    render layout: nil
  end

  def realtime
    @categories = []
    @event = Event.new
    @event.realtime = true
    
    if !params[:categories].nil?
      category_names = params[:categories].split(",")
      category_names.each { |category_name| 
      
        category = TweetCategory.find_by_category(category_name)
        if category
          @categories.push(category)
        end
      }
    end
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

  def get_volumes(categories, starttime, endtime)
    
    starttime = starttime.to_datetime.change(:sec => 0)
    endtime = endtime.to_datetime.change(:sec => 0)   
    difference = (endtime.to_i - starttime.to_i) / 60

    # initialize the volhash
    volhash = {}
    timecounter = starttime.clone
    0.upto(difference) { |m| 
      vol = {}
      vol[:time] = timecounter
      categories.each { |c| 
        vol[c.category] = 0
      }
      
      volhash[timecounter] = vol
      timecounter = timecounter.advance(:minutes => 1)
    }

    categories.each { |category| 

      cat_volumes = category.tweet_volumes.find(:all, :conditions => ["time >= ? AND time <= ?", starttime, endtime])
      cat_volumes.each { |vol| 
        
        volhash[vol.time.to_datetime][category.category] += vol.count
      }
    }
    
    volumes = []
    timecounter = starttime.clone
    0.upto(difference) { |m| 
      volumes.push(volhash[timecounter])
      timecounter = timecounter.advance(:minutes => 1)      
    }
    
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
  
  private
  
  def earliest_date(date1,date2)
    if !date1
      date2
    else
      date1 < date2 ? date1 : date2
    end
  end
  
  def latest_date(date1,date2)
    if !date1
      date2
    else
      date1 > date2 ? date1 : date2
    end
  end
  
end
