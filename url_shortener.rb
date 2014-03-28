require 'sinatra/base'
require 'uri'

class App < Sinatra::Application

  SITES = {}
  CURRENT = []

  get '/' do
    erb :index
  end

  post '/' do
    url = params[:shorten_url]

    if url =~ /^#{URI::regexp}$/
      id = SITES.length + 1
      SITES[id] = [url, "http://secret-hollows-7655.herokuapp.com/#{id}"]
      CURRENT = [url, "http://secret-hollows-7655.herokuapp.com/#{id}"]
      redirect "/items"
    else
      erb :error, locals: {message: "You must enter a valid URL."}
    end

  end

  get '/items' do
    erb :items, locals: {sites: SITES, current: CURRENT}
  end

  get '/:id' do
    id = params[:id].to_i
    new_url = SITES[id][0]
    redirect "#{new_url}"
  end

end



