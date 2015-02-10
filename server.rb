require 'sinatra'
require 'rest-client'
require 'json'

class ListMore::Server < Sinatra::Application

  set :bind '0.0.0.0'

  get '/' do
    "First test starter"
  end

  # post '/lists' do
  #   user = ListMore::VerifyToken.run params
  #   params[:user_id] = user.id
  #   ListMore::CreateList.run params
  # end

end

