# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140618202631) do

  create_table "events", :force => true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "rate_limits", :force => true do |t|
    t.integer  "skipcount"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "tweet_category_id"
  end

  add_index "rate_limits", ["created_at"], :name => "index_rate_limits_on_created_at"
  add_index "rate_limits", ["tweet_category_id"], :name => "index_rate_limits_on_tweet_category_id"

  create_table "recorders", :force => true do |t|
    t.string   "category"
    t.string   "query"
    t.string   "oauth_access_token"
    t.string   "oauth_access_secret"
    t.string   "status"
    t.boolean  "running"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "screen_name"
  end

  create_table "tweet_categories", :force => true do |t|
    t.string   "category"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tweet_categories_tweets", :id => false, :force => true do |t|
    t.integer "tweet_id",          :limit => 8
    t.integer "tweet_category_id"
  end

  add_index "tweet_categories_tweets", ["tweet_category_id"], :name => "index_tweet_categories_tweets_on_tweet_category_id"
  add_index "tweet_categories_tweets", ["tweet_id"], :name => "index_tweet_categories_tweets_on_tweet_id"

  create_table "tweet_errors", :force => true do |t|
    t.string   "message"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "tweet_category_id"
  end

  create_table "tweet_volumes", :force => true do |t|
    t.datetime "time"
    t.integer  "count"
    t.integer  "tweet_category_id"
  end

  create_table "tweets", :force => true do |t|
    t.string   "text"
    t.datetime "created_at",                        :null => false
    t.string   "screenname"
    t.integer  "user_id"
    t.datetime "updated_at",                        :null => false
    t.string   "lang"
    t.string   "json",              :limit => 7500
    t.integer  "tweet_category_id"
  end

  add_index "tweets", ["created_at"], :name => "index_tweets_on_created_at"
  add_index "tweets", ["tweet_category_id"], :name => "index_tweets_on_tweet_category_id"

  create_table "tweets_1", :force => true do |t|
    t.string   "text"
    t.datetime "created_at",                        :null => false
    t.string   "screenname"
    t.integer  "user_id"
    t.datetime "updated_at",                        :null => false
    t.string   "lang"
    t.string   "json",              :limit => 7500
    t.integer  "tweet_category_id"
  end

  add_index "tweets_1", ["created_at"], :name => "index_tweets_on_created_at"
  add_index "tweets_1", ["tweet_category_id"], :name => "index_tweets_on_tweet_category_id"

  create_table "tweets_2", :force => true do |t|
    t.string   "text"
    t.datetime "created_at",                        :null => false
    t.string   "screenname"
    t.integer  "user_id"
    t.datetime "updated_at",                        :null => false
    t.string   "lang"
    t.string   "json",              :limit => 7500
    t.integer  "tweet_category_id"
  end

  add_index "tweets_2", ["created_at"], :name => "index_tweets_on_created_at"
  add_index "tweets_2", ["tweet_category_id"], :name => "index_tweets_on_tweet_category_id"

  create_table "tweets_3", :force => true do |t|
    t.string   "text"
    t.datetime "created_at",                        :null => false
    t.string   "screenname"
    t.integer  "user_id"
    t.datetime "updated_at",                        :null => false
    t.string   "lang"
    t.string   "json",              :limit => 7500
    t.integer  "tweet_category_id"
  end

  add_index "tweets_3", ["created_at"], :name => "index_tweets_on_created_at"
  add_index "tweets_3", ["tweet_category_id"], :name => "index_tweets_on_tweet_category_id"

  create_table "tweets_4", :force => true do |t|
    t.string   "text"
    t.datetime "created_at",                        :null => false
    t.string   "screenname"
    t.integer  "user_id"
    t.datetime "updated_at",                        :null => false
    t.string   "lang"
    t.string   "json",              :limit => 7500
    t.integer  "tweet_category_id"
  end

  add_index "tweets_4", ["created_at"], :name => "index_tweets_on_created_at"
  add_index "tweets_4", ["tweet_category_id"], :name => "index_tweets_on_tweet_category_id"

  create_table "tweets_5", :force => true do |t|
    t.string   "text"
    t.datetime "created_at",                        :null => false
    t.string   "screenname"
    t.integer  "user_id"
    t.datetime "updated_at",                        :null => false
    t.string   "lang"
    t.string   "json",              :limit => 7500
    t.integer  "tweet_category_id"
  end

  add_index "tweets_5", ["created_at"], :name => "index_tweets_on_created_at"
  add_index "tweets_5", ["tweet_category_id"], :name => "index_tweets_on_tweet_category_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "admin",               :default => false
  end

end
