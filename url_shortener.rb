require 'sinatra/base'
require 'uri'

class App < Sinatra::Application

  SITES = {}
  CURRENT = []
  COUNT = {}


  get '/' do
    message = nil
    erb :index, locals: {message: message}
  end

  post '/' do
    message = ""
    url = params[:shorten_url]
    vanity_url = params[:vanity_url]
    if url =~ /^#{URI::regexp}$/
      id = SITES.length + 1
      if vanity_url.empty?
        SITES[id] = [url, "http://secret-hollows-7655.herokuapp.com/#{id}"]
        CURRENT = [url, "http://secret-hollows-7655.herokuapp.com/#{id}"]
      else
        SITES[id] = [url, vanity_url]
        CURRENT = [url, vanity_url]
      end

      COUNT[id] = 0
      redirect "/items/#{id}"
    elsif url.empty?
      message = "The URL cannot be blank."
    else
      message = "You must enter a valid URL."
    end


    erb :index, locals: {message: message}
  end

  get '/items/:id' do
    id = params[:id].to_i
    CURRENT = SITES[id]
    erb :items, locals: {sites: SITES, current: CURRENT, count: COUNT, id: id}
  end

  get '/:id' do
    id = params[:id].to_i
    COUNT[id] += 1
    new_url = SITES[id][0]
    redirect "#{new_url}"
  end

end



