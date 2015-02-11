require 'pry-byebug'
require 'sinatra'
require 'rest-client'
require 'json'
require 'sinatra/base'

class ListMore::Server < Sinatra::Application

  set :bind, '0.0.0.0'

  get '/' do
    send_file 'public/index.html'
  end

  post '/signup' do
    data = {}
    result = ListMore::SignUp.run params

    if result.success?
      data[:token] = result.token
      data[:user] = ListMore::Serializer.run result.user
    end

    data.to_json
  end

  post '/signin' do
    data = {}
    result = ListMore::SignIn.run params

    if result.success?
      data[:token] = result.token
      data[:user] = ListMore::Serializer.run result.user
    end

    binding.pry

    data.to_json
  end

  get '/users' do
    users = ListMore.users_repo.all
    data = users.map { |x| ListMore::Serializer.run x }
    {
      'users' => data
    }.to_json
  end

  # post '/lists' do
  #   user = ListMore::VerifyToken.run params
  #   params[:user_id] = user.id
  #   ListMore::CreateList.run params
  # end

end

