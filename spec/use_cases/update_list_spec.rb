require 'spec_helper'
require 'pry-byebug'

describe ListMore::UpdateList do

  let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }
  let(:user_1) { ListMore::Entities::User.new({:username => "Ramses", :password => "pitbull"})}

  before(:each) do
    dbhelper.drop_tables 
    dbhelper.create_tables 
  end

  it "will update the name of an existing list" do
    init_params = {
      'name' => "Dogs"
    }
    user_1.update_password user_1[:password]
    user = ListMore.users_repo.save user_1
    response = ListMore::SignIn.run user

    init_params['token'] = response.token
    result = ListMore::CreateList.run init_params
    
    params = result.list
    params['token'] = init_params['token']
    params['name'] = "Updated Dogs"
    updated_list_result = ListMore::UpdateList.run params

    expect(updated_list_result.list.name).to eq "Updated Dogs"
    expect(updated_list_result.list.id).to eq result.list.id
    expect(updated_list_result.success?).to be_true
  end
end