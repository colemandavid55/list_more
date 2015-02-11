require 'spec_helper'
require 'pry-byebug'
require 'pg'

describe ListMore::Repositories::SharedListsRepo do

  let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }
  let(:user_1) { ListMore::Entities::User.new({:username => "Ramses", :password_digest => "pitbull"})}
  let(:user_2) { ListMore::Entities::User.new({:username => "Daisy", :password_digest => "collie"})}
  

  before(:each) do
    dbhelper.drop_tables
    dbhelper.create_tables
  end

  it "allows a user to share a list with another user" do
    saved_user_1 = ListMore.users_repo.save user_1
    saved_user_2 = ListMore.users_repo.save user_2

    list_data = {
      'name' => "Shared List",
      'user_id' => saved_user_1.id
    }

    saved_list = ListMore::CreateList.run list_data
    list_id = saved_list.list.id 

    params = {
      'user_id' => saved_user_2.id,
      'list_id' => list_id
    }

    result = ListMore::ShareList.run params

    expect(result.shared_list['user_id']).to eq saved_user_2.id
    expect(result.shared_list['list_id']).to eq list_id
  end
end