require 'server_spec_helper'
require 'pry-byebug'
# require 'pg'

describe ListMore::Server do

  def app
    ListMore::Server.new
  end

  let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }
  let(:user_1) { ListMore::Entities::User.new({:username => "Ramses", :password_digest => "pitbull"})}
  let(:user_2) { ListMore::Entities::User.new({:username => "Daisy", :password_digest => "collie"})}
  let(:users) { [user_1, user_2] }

  before(:all) do
    dbhelper.clear_tables
    users.each{ |user| ListMore.users_repo.save user }
  end

  # before(:each) do
  #   dbhelper.clear_tables
  #   users.each{ |user| ListMore.users_repo.save user }
  # end

  describe "GET /" do
    xit "loads the homepage" do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include "Loading.."
    end
  end


  describe "POST /signup" do
    xit "makes a successful post request to signup endpoint" do
      params = {
        :username      => "Duevyn",
        :password      => "Cooke",
        :password_conf => "Cooke"
      }
      post '/signup', params
      response = last_response.body
      response = JSON.parse(response)
# {"token"=>"31fcf684ff4e62591528c2f183ca5468", "user"=>{"id"=>41, "username"=>"Duevyn", "email"=>nil}}
      expect(response['token']).to be_a String
      expect(response['user']).to be_a Hash
      expect(response['user']['id'].to_i).to be_a Integer
      expect(response['user']['username']).to eq "Duevyn"
    end
  end

  describe "POST /signin" do
    xit "makes a successful post request to signin endpoint" do
      user = ListMore::Entities::User.new({username: 'nick'})
      user.update_password("mks123")
      ListMore.users_repo.save user
      params = {
        :username   => "nick",
        :password   => "mks123"
      }
      post '/signin', params
      response = last_response.body

      response = JSON.parse(response)

      expect(response['token']).to be_a String
      expect(response['user']).to be_a Hash
      expect(response['user']['id'].to_i).to be_a Integer
      expect(response['user']['username']).to eq "nick"

    end
  end

  describe "GET /users" do
    xit "makes a successfull get request to the users endpoint" do
      get '/users'
      expect(last_response).to be_ok
      data = last_response.body
#data "{\"users\":[{\"id\":19,\"username\":\"Ramses\"},{\"id\":20,\"username\":\"Daisy\"}]}"
      data = JSON.parse(data)
      # expect(data['users'].count).to eq 2
      data['users'].each do |user|
        expect(user['id'].to_i).to be_a Integer
        expect(user['username']).to be_a String
        expect(user['password']).to be_nil
      end
    end
  end

  describe "GET /users/:id" do
    xit "makes a successful get request to an individul user endpoint" do
      params = {
        :id => users[0]['id']
      }
      get '/users/' + params[:id], params

      response = last_response.body
# "{\"user\":{\"id\":111,\"username\":\"Ramses\",\"email\":null}}"
      data = JSON.parse(last_response.body)
      expect(data['user']).to be_a Hash
      expect(data['user']['username']).to eq "Ramses"
      expect(data['user']['id'].to_i).to be_a Integer
      expect(data['user']['email']).to be_nil
    end
  end

  describe "GET /users/:id/lists" do
    xit "gets all lists of a user from endpoint" do
      first_user = users[0]
      second_user = users[1]
      list_1 = ListMore::Entities::List.new({name: "First List", user_id: first_user['id'] })
      list_2 = ListMore::Entities::List.new({name: "Second List", user_id: first_user['id'] })
      list_3 = ListMore::Entities::List.new({name: "Share List", user_id: second_user['id'] })
      receive_list = ListMore.lists_repo.save list_1
      ListMore.lists_repo.save list_2
      share_list = ListMore.lists_repo.save list_3

      params = {
        'user_id' => receive_list['user_id'],
        'list_id' => share_list['id']
      }

      shared_list_data = ListMore::ShareList.run params



      params = {
        'user' => first_user
      }

      # binding.pry


      get '/users/' + first_user.id + '/lists' #, params
      response = JSON.parse(last_response.body)

      expect()

      binding.pry
    end
  end

  describe "POST /users/:id/lists" do
    xit "makes a successful post request to the endpoint creating a new list" do
      user = users[0]
      params = {
        'name'    => 'Post List',
        'user_id' => user['id']
      }

      ListMore::CreateList.run params
    end
  end
end
