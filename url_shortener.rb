require 'sinatra/base'
require 'uri'

class App < Sinatra::Application

  SITES = {}
  CURRENT = []

  get '/' do
    message = nil
    erb :index, locals: {message: message}
  end

  post '/' do
    message = ""
    url = params[:shorten_url]
    if url =~ /^#{URI::regexp}$/
      id = SITES.length + 1
      SITES[id] = [url, "http://secret-hollows-7655.herokuapp.com/#{id}"]
      CURRENT = [url, "http://secret-hollows-7655.herokuapp.com/#{id}"]
      redirect "/items/#{id}"
    elsif url.empty?
      message = "The URL cannot be blank."
    else
      message = "You must enter a valid URL."
    end
    erb :index, locals: {message: message}
  end

  get '/items/:id' do
    erb :items, locals: {sites: SITES, current: CURRENT}
  end

  get '/:id' do
    id = params[:id].to_i
    new_url = SITES[id][0]
    redirect "#{new_url}"
  end

end



