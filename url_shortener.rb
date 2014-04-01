require 'sinatra/base'
require 'uri'
require 'obscenity'
require 'yaml'

class App < Sinatra::Application

  DB = {}
  VANITYID = {}
  MESSAGE = nil
  MESSAGE_COUNT = 0

  get '/' do
    if MESSAGE_COUNT > 0
      MESSAGE = nil
      MESSAGE_COUNT = 0
    else
      MESSAGE_COUNT += 1
    end

    erb :index, locals: {message: MESSAGE}

  end

  post '/' do
    MESSAGE = nil
    MESSAGE_COUNT = 0
    url = params[:shorten_url]
    vanity_url = params[:vanity_url]
    if Obscenity.profane? (vanity_url)
      MESSAGE = "Vanity url cannot have profanity"
      redirect '/'
    end

    if vanity_url.length > 12
      MESSAGE = "Vanity url cannot be more than 12 characters"
      redirect '/'
    end

    if vanity_url.match (/[^A-Za-z]/)
      MESSAGE = "Vanity must contain only letters"
      redirect '/'
    end

    if url =~ /^#{URI::regexp}$/
      id = DB.length + 1
      DB[id] = {}
      DB[id][:count] = 0
      if vanity_url.empty?
        DB[id][:url] = url
        DB[id][:shortened_url] = "http://secret-hollows-7655.herokuapp.com/#{id}"
      else
        if VANITYID.has_key?(vanity_url)
          MESSAGE = "URL already taken: #{vanity_url}"
          redirect '/'
        else
          DB[id][:url] = url
          DB[id][:shortened_url] = "http://secret-hollows-7655.herokuapp.com/#{vanity_url}"
          VANITYID[vanity_url] = id
        end
      end
      redirect "#{id}?stats=true"
    elsif url.empty?
      MESSAGE = "The URL cannot be blank."
    else
      MESSAGE = "#{url} is not a valid URL."
    end
    #erb :index, locals: {message: MESSAGE}
    redirect '/'
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



