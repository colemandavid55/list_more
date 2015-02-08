require 'spec_helper'

describe ListMore::CreateSession do

  let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }

  before(:each) do
    dbhelper.drop_tables 
    dbhelper.create_tables 
  end

  it "creates a session" do
    user_data = {
        'username' => "Ramses",
        'password' => "pitbull",
        'password_conf' => "pitbull"
                }
    user = ListMore::Entities::User.new user_data
    user = ListMore.users_repo.save user

    response = ListMore::CreateSession.run user
    expect(response.token).to be_a String
    expect(response.token.length).to eq 32

    user_confirm = ListMore.users_repo.find_by_token response.token
    expect(user_confirm.username).to eq "Ramses"
  end

end