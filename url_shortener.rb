require 'sinatra/base'
require 'uri'
require 'obscenity'
require 'yaml'

class App < Sinatra::Application

  SITES = {}
  CURRENT = []
  COUNT = {}
  VANITYID = {}
  MESSAGE = nil

  get '/' do
    erb :index, locals: {message: MESSAGE}
  end

  post '/' do
    MESSAGE = ""
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
      id = SITES.length + 1
      COUNT[id] = 0
      if vanity_url.empty?
        SITES[id] = [url, "http://secret-hollows-7655.herokuapp.com/#{id}"]
        CURRENT = [url, "http://secret-hollows-7655.herokuapp.com/#{id}"]
      else
        if VANITYID.has_key?(vanity_url)
          MESSAGE = "URL already taken: #{vanity_url}"
          redirect '/'
        else
          SITES[id] = [url, "http://secret-hollows-7655.herokuapp.com/#{vanity_url}"]
          CURRENT = [url, "http://secret-hollows-7655.herokuapp.com/#{vanity_url}"]
          VANITYID[vanity_url] = id
        end
      end
      redirect "#{id}?stats=true"
    elsif url.empty?
      MESSAGE = "The URL cannot be blank."
    else
      MESSAGE = "#{url} is not a valid URL."
    end
    erb :index, locals: {message: MESSAGE}
  end

  get '/:id?' do
    id = params[:id].to_i
    CURRENT = SITES[id]
    erb :items, locals: {sites: SITES, current: CURRENT, count: COUNT, id: id}
  end

  get '/:id' do
    id = params[:id]
    if id.to_i.to_s == id
      COUNT[id.to_i] += 1
      new_url = SITES[id.to_i][0]
    else
      id_num = VANITYID[id]
      new_url = SITES[id_num][0]
      COUNT[id_num] += 1
    end
    redirect "#{new_url}"
  end

end



