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
    params = {
      'name' => "This is the name of a list"
    }
    user_1.update_password user_1[:password]
    user = ListMore.users_repo.save user_1
    response = ListMore::SignIn.run user
    params['token'] = response.token
    result = ListMore::CreateList.run params
    # binding.pry
    item_params['token'] = params['token']
    item_params['list_id'] = result.list.id
    # binding.pry
    result = ListMore::CreateItem.run item_params
    # binding.pry
    expect(result.item.content).to eq "This is the content of an item"
    expect(result.item.list_id).to eq "1"
    expect(result.item.user_id).to eq "1"
    expect(result.success?).to be_true
  end

end