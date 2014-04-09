require 'sinatra/base'
require_relative 'lib/url_validator'
require_relative 'lib/url_repository'
#require 'dotenv'
#Dotenv.load

class App < Sinatra::Application

  MESSAGE = nil
  MESSAGE_COUNT = 0
  FIELD = ""

  get '/' do
    if MESSAGE_COUNT > 0
      MESSAGE = nil
      MESSAGE_COUNT = 0
      FIELD = ""
    else
      MESSAGE_COUNT += 1
    end
    erb :index, locals: {message: MESSAGE, field: FIELD}
  end

  post '/' do
    MESSAGE = nil
    MESSAGE_COUNT = 0
    FIELD = ""
    url = params[:shorten_url]
    vanity_url = params[:vanity_url]
    current_url = URLvalidator.new(url, vanity_url)
    if !current_url.is_valid?
      MESSAGE = current_url.error_message
      FIELD = url
      redirect '/'
    elsif !vanity_url.empty? && DB.vanity_taken?(vanity_url)
      MESSAGE = "URL already taken: #{vanity_url}"
      FIELD = url
      redirect '/'
    else
      vanity_url.empty?
      id = DB.add_url(url, vanity_url)
      redirect "#{id}?stats=true"
    end
  end

  get '/:id' do
    id = params[:id]
    if params[:stats]
      erb :items, locals: {site: DB.get_stats(id, base_url)}
    else
      redirect "#{DB.get_url(id)}"
    end
  end

  get '/favicon.ico' do
    "None here"
  end

  helpers do
    def base_url
      @base_url ||= request.base_url
    end
  end

end