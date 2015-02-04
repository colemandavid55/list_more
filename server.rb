require 'sinatra'
require 'rest-client'
require 'json'

class ListMore::Server < Sinatra::Application

  set :bind '0.0.0.0'

  get '/' do
    "First test starter"
  end

end

