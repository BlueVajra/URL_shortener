require 'sinatra/base'
require 'uri'
require 'yaml'
require_relative 'lib/url_validator'

class App < Sinatra::Application

  DB = {}
  VANITYID = {}
  MESSAGE = nil
  MESSAGE_COUNT = 0
  FIELD =""

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
      redirect '/'
    else
      if vanity_url.empty? || !VANITYID.has_key?(vanity_url)
        id = DB.length + 1
        DB[id] = {}
        DB[id][:count] = 0
        DB[id][:url] = url
        if vanity_url.empty?
          DB[id][:shortened_url] = "http://secret-hollows-7655.herokuapp.com/#{id}"
        else
          DB[id][:shortened_url] = "http://secret-hollows-7655.herokuapp.com/#{vanity_url}"
          VANITYID[vanity_url] = id
        end
        redirect "#{id}?stats=true"
      else
        MESSAGE = "URL already taken: #{vanity_url}"
        FIELD = url
        redirect '/'
      end
    end
  end

  get '/:id' do
    if params[:stats]
      id = params[:id].to_i
      erb :items, locals: {sites: DB[id]}
    else
      id = params[:id]
      if id.to_i.to_s == id
        DB[id.to_i][:count] += 1
        new_url = DB[id.to_i][:url]
      else
        id_num = VANITYID[id]
        new_url = DB[id_num][:url]
        DB[id_num][:count] += 1
      end
      redirect "#{new_url}"
    end
  end

end



