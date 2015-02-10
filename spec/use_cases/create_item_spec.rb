require 'spec_helper'
require 'pry-byebug'

describe ListMore::CreateItem do

  let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }
  let(:user_1) { ListMore::Entities::User.new({:username => "Ramses", :password_digest => "pitbull"})}
  

  before(:each) do
    dbhelper.drop_tables 
    dbhelper.create_tables 
  end

  it "will create an item" do
    user = ListMore.users_repo.save user_1
    list_1 = ListMore::Entities::List.new({:user_id => user.id, :name => "List Name"})
    list = ListMore.lists_repo.save list_1

    params = {
      'content' => "This is the content of an item"
    }
    params['user_id'] = user.id
    params['list_id'] = list.id

    result = ListMore::CreateItem.run params

    expect(result.item.content).to eq "This is the content of an item"
    expect(result.item.list_id).to eq "1"
    expect(result.item.user_id).to eq "1"
    expect(result.success?).to be_true
  end

end