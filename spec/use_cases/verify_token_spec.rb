require 'spec_helper'
require 'pry-byebug'

describe ListMore::VerifyToken do

  let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }
  let(:user_1) { ListMore::Entities::User.new({:username => "Ramses", :password => "pitbull"})}

  before(:each) do
    dbhelper.drop_tables 
    dbhelper.create_tables 
  end

  it "will verify the token of an existing user" do
    params = {}
    user = ListMore.users_repo.save user_1
    session = ListMore::CreateSession.run user

    params['token'] = session.token
    result = ListMore::VerifyToken.run params
    expect(result).to be_true
  end

  it "will reject an incorrect token" do
    params = {}
    params['token'] = "laksdl7q4rquwgl47gqi4g"
    result = ListMore::VerifyToken.run params
    expect(result).to be_false
  end

end