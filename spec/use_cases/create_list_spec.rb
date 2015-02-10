require 'spec_helper'
require 'pry-byebug'

describe ListMore::CreateList do

  let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }
  let(:user_1) { ListMore::Entities::User.new({:username => "Ramses", :password_digest => "pitbull"})}

  before(:each) do
    dbhelper.drop_tables 
    dbhelper.create_tables 
  end

  it "will create a list" do
    user = ListMore.users_repo.save user_1

    params = {
      'name' => "Dogs",
      'user_id' => user.id
    }

    result = ListMore::CreateList.run params

    expect(result.success?).to be_true
    expect(result.list.name).to eq "Dogs"
    expect(result.list.user_id).to eq "1"
    expect(result.list.id.to_i).to be_a Integer
  end
end