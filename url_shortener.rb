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
    redirect "/items"
  end

  get '/items' do
    erb :items, locals: {sites: SITES}
  end

  get '/:id' do
    id = params[:id].to_i
    new_url = SITES[id][0]
    redirect "#{new_url}"
  end

end


#SITES = {1, [old_url, new_url]}
#
#SITES[id][0] = SITES[id][1]