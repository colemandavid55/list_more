require 'spec_helper'
require 'bcrypt'
require 'pry-byebug'

describe ListMore::SignIn do

  let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }
  let(:user_1) { ListMore::Entities::User.new({:username => "Ramses", :password => "pitbull"})}

  before(:each) do
    dbhelper.drop_tables 
    dbhelper.create_tables 
  end

  context "when the form is filled out correctly" do
    it "will sign in a registered user" do
      params = {
        'username' => "Ramses",
        'password' => "pitbull"
      }
      user_1.update_password user_1[:password]
      user = ListMore.users_repo.save user_1
      # binding.pry
      # user_1 = ListMore.users_repo.save user_1
      # binding.pry
      response = ListMore::SignIn.run params
      # binding.pry
      expect(response.success?).to be_true
    end
  end

  context "when the form is filled out incorrectly" do
    it "will not sign in a registered user" do
      params = {
        'username' => "Ramses",
        'password' => nil
      }
      user = ListMore.users_repo.save user_1
      response = ListMore::SignIn.run params
      expect(response.success?).to be_false
    end

    it "will not sign in an unregistered user" do
      params = {
        'username' => "Daisy",
        'password' => "collie"
      }
      response = ListMore::SignIn.run params
      expect(response.success?).to be_false
    end
  end
end
