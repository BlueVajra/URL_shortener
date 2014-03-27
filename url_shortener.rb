require 'sinatra/base'

class App < Sinatra::Application

  get '/' do
    erb :index
  end
end