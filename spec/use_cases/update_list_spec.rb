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
    user = ListMore.users_repo.save user_1

    params = {
      'name' => "Dogs",
      'user_id' => user.id
    }

    response = ListMore::CreateList.run params

    params['name'] = "Updated Dogs"
    params['id'] = response.list.id

    result = ListMore::UpdateList.run params

    expect(result.list.name).to eq "Updated Dogs"
    expect(result.list.id).to eq response.list.id
    expect(result.success?).to be_true
  end
end