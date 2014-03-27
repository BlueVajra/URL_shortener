require 'sinatra/base'

class App < Sinatra::Application

  SITES = {}

  get '/' do
    erb :index
  end

  post '/' do
    url = params[:shorten_url]
    id = SITES.length + 1
    SITES[id] = [url, "http://secret-hollows-7655.herokuapp.com/#{id}"]
    redirect "/#{id}"
  end

  get '/:id' do
    erb :id, locals: {sites: SITES}
  end
end