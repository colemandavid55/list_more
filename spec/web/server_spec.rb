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

  describe "GET /" do
    it "loads the homepage" do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include "Loading.."
    end
  end

  describe "GET /users" do
    it "makes a successfull get request to the users endpoint" do
      get '/users'
      expect(last_response).to be_ok
      data = last_response.body
#data "{\"users\":[{\"id\":19,\"username\":\"Ramses\"},{\"id\":20,\"username\":\"Daisy\"}]}"
      data = JSON.parse(data)
      expect(data['users'].count).to eq 2
      data['users'].each do |user|
        expect(user['id'].to_i).to be_a Integer
        expect(user['username']).to be_a String
        expect(user['password']).to be_nil
      end
    end
  end

  describe "POST /signup" do
    it "makes a successful post request to signup endpoint" do
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
    it "makes a successful post request to signin endpoint" do
      params = {
        :username   => "Duevyn",
        :password   => "Cooke"
      }
      post '/signin', params
      response = last_response.body
      binding.pry
      response = JSON.parse(response)

      expect(response['token']).to be_a String
      expect(response['user']).to be_a Hash
      expect(response['user']['id'].to_i).to be_a Integer
      expect(response['user']['username']).to eq "Duevyn"

    end
  end

end
