require 'spec_helper'
require 'pry-byebug'

describe ListMore::CreateItem do

  let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }
  let(:user_1) { ListMore::Entities::User.new({:username => "Ramses", :password => "pitbull"})}

  before(:each) do
    dbhelper.drop_tables 
    dbhelper.create_tables 
  end

  it "will create an item" do
    item_params = {
      'content' => "This is the content of an item"
    }
    list_params = {
      'name' => "This is the name of a list"
    }
    user_1.update_password user_1[:password]
    user = ListMore.users_repo.save user_1
    response = ListMore::SignIn.run user
    list_params['token'] = response.token
    result = ListMore::CreateList.run list_params
    binding.pry
  end

end