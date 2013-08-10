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

      @endtime = 1.minutes.ago.utc.change(:sec => 0)
      @starttime = 91.minutes.ago.utc.change(:sec => 0)

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

      @endtime = 1.minutes.ago.utc.change(:sec => 0)
      @starttime = 121.minutes.ago.utc.change(:sec => 0)

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

    @time = 1.minutes.ago.utc
    if !params[:time].nil?
      @time = DateTime.parse(params[:time]).utc
    end
    
    @endtime = @time.advance(:minutes => 1)
    @tweets = @category.tweets.find(:all, :conditions => ["created_at >= ? AND created_at < ? AND lang = ?", @time, @endtime, "en"])
  end
  
  private
  
  def calculate_and_cache_volumes(category, starttime, endtime)
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
end
