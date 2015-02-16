require 'pry-byebug'
require 'sinatra'
require 'rest-client'
require 'json'
require 'sinatra/base'

class ListMore::Server < Sinatra::Application

  set :bind, '0.0.0.0'

  before do
    # request.body.rewind

    @body = request.body.read
    @body = "{}" if @body.length == 0
    @params = JSON.parse(@body)
    puts "Got params: #{@params}"

    puts "PATH INFO: #{request.path_info.inspect}"
    pass if ['/', '/signup', '/signin'].include? request.path_info
    
    verified = ListMore::VerifyToken.run @params
    return {error: 'not authenticated'}.to_json unless verified
  end

  get '/' do
    send_file 'public/index.html'
  end

  post '/signup' do

    json = request.body.read

    params = JSON.parse(json)
    data = {}
    result = ListMore::SignUp.run params
    puts result

    if result.success?
      data[:token] = result.token
      data[:user] = ListMore::Serializer.run result.user
    else
      status 403
      return  {error: "please fill out all fields"}.to_json
    end

    data.to_json
  end

  post '/signin' do
    # json = request.body.read
    # puts json
    # params = JSON.parse(json)
    # params = JSON.parse(request.body.rewind)
    data = {}
    result = ListMore::SignIn.run @params

    if result.success?
      data[:token] = result.token
      data[:user] = ListMore::Serializer.run result.user
    else
      status 403
      return {error: "incorrect login credentials"}.to_json
    end

    data.to_json
  end

  post '/logout' do
    puts request.body.read
    ListMore.sessions_repo.delete params['token']
  end

  get '/users' do
    users = ListMore.users_repo.all
    data = users.map { |user| ListMore::Serializer.run user }
    {
      'users' => data
    }.to_json
  end

  get '/users/:id' do
    user = ListMore.users_repo.find_by_id @params['id']
    data = ListMore::Serializer.run user
    {
      'user' => data
    }.to_json
  end

  get '/users/:id/lists' do
    user_lists = ListMore.lists_repo.get_user_lists @params['id']
    shared_lists = ListMore.lists_repo.get_lists_shared_with_user @params['id']

    lists_data = user_lists.map{ |list| ListMore::Serializer.run list}
    shared_lists_data = shared_lists.map{ |shared_list| ListMore::Serializer.run shared_list }

    {
      'user_lists'   => lists_data,
      'shared_lists' => shared_lists_data
    }.to_json
  end

  post '/users/:id/lists' do
    # params = JSON.parse request.body.read
    list = ListMore::CreateList.run @params
    list_data = ListMore::Serializer.run list
    {
      'list' => list_data
    }.to_json
  end

  put '/lists/:id' do
    result = ListMore::UpdateList.run params
    # should i get all lists again here or "redirect" to get all lists for a user endpoint?
    if result.success?
      {success: true}.to_json
    else
      # some error
    end
  end

  delete '/lists/:id' do
    list = ListMore.lists_repo.find_by_id params[:id]
    ListMore.lists_repo.destroy_list list
    # check for success 
  end

  get '/lists/:id' do
    # puts request.body.read
    items = ListMore.items_repo.get_list_items @params['id']
    items_data = items.map{ |item| ListMore::Serializer.run item }
    {
      'items' => items_data
    }.to_json
  end

  post '/lists/:list_id/items' do
    params = JSON.parse request.body.read
    item = ListMore::CreateItem.run params
    item_data = ListMore::Serializer.run item
    {
      'item' => item_data
    }.to_json
  end

  put '/lists/:list_id/items' do
    result = ListMore::UpdateItem.run params
    if result.success?
      {success: true}.to_json
    else
      # some error
    end
  end

  delete '/items/:id' do
    params = JSON.parse request.body.read
    puts params
    item = ListMore.items_repo.find_by_id params['id']
    ListMore.items_repo.destroy_item item.id
    # check for success
  end

  post '/share_list' do
    shared_list = ListMore::ShareList params
    shared_list_data = ListMore::Serializer.run shared_list
    # will serializer work in this context?
    {
      'shared_list' => shared_list_data
    }.to_json
  end

  delete '/share_list/:id' do
    ListMore.shared_lists_repo.delete params
    # check for success
  end

  # post '/lists' do
  #   user = ListMore::VerifyToken.run params
  #   params[:user_id] = user.id
  #   ListMore::CreateList.run params
  # end

end

# resources :posts do
#   resources :comments
# end

# delete '/comments/:id'