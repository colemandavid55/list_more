require 'spec_helper'
require 'pry-byebug'

describe ListMore::UpdateItem do

  let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }
  let(:user_1) { ListMore::Entities::User.new({:username => "Ramses", :password => "pitbull"})}

  before(:each) do
    dbhelper.drop_tables 
    dbhelper.create_tables 
  end

  it "will update an existing item" do
    user = ListMore.users_repo.save user_1

    params = {
      'name' => "Dogs",
      'user_id' => user.id
    }

    result = ListMore::CreateList.run params

    params['list_id'] = result.list.id
    params['content'] = "Original content"
    response = ListMore::CreateItem.run params

    params = response.item

    params['content'] = "Updated content"
    final_response = ListMore::UpdateItem.run params

    expect(final_response.success?).to be_true
    expect(final_response.item.id).to eq response.item.id
    expect(final_response.item.content).to eq "Updated content"
    expect(final_response.item.list_id).to eq response.item.list_id
    expect(final_response.item.user_id).to eq response.item.user_id
  end

end