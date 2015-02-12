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

    data.to_json
  end

  get '/users' do
    users = ListMore.users_repo.all
    data = users.map { |user| ListMore::Serializer.run user }
    {
      'users' => data
    }.to_json
  end

  get '/users/:id' do
    user = ListMore.users_repo.find_by_id params[:id]
    data = ListMore::Serializer.run user
    {
      'user' => data
    }.to_json
  end

  get '/users/:id/lists' do
    user_lists = ListMore.lists_repo.all
    shared_lists = ListMore.lists_repo.get_lists_shared_with_user params['id']
    binding.pry
    list_data = user_lists.map{ |list| ListMore::Serializer.run list}
    shared_list_data = shared_lists.map{ |shared_list| ListMore::Serializer.run shared_list }

    {
      'user_lists'   => list_data,
      'shared_lists' => shared_list_data
    }.to_json
  end

  post '/users/:id/lists' do
    data = ListMore::CreateList.run params
    binding.pry
  end

  delete '/users/:id/lists' do
    ListMore.lists_repo.delete params
  end

  get '/users/:user_id/lists/:id' do
    data = ListMore.items_repo.get_list_items params
  end

  post '/lists/:list_id/items' do
    data = ListMore::CreateItem.run params
  end

  delete '/lists/:list_id/items' do
    ListMore.items_repo.delete params
  end

  # post '/lists' do
  #   user = ListMore::VerifyToken.run params
  #   params[:user_id] = user.id
  #   ListMore::CreateList.run params
  # end

end

