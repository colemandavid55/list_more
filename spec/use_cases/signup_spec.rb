require 'spec_helper'

describe ListMore::SignUp do

  let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }

  before(:each) do
    dbhelper.drop_tables 
    dbhelper.create_tables 

  end

  context "when the form is filled out properly" do
    it "will sign up a user" do
      user_data = {
        'username' => "Ramses",
        'password' => "pitbull",
        'password_conf' => "pitbull"
      }
      response = ListMore::SignUp.run user_data
      expect(response.success?).to be_true
    end
  end

  context "when the form is filled out incorrectly" do

    it "will not sign up a user when passwords do not match" do
      user_data = {
        'username' => "Ramses",
        'password' => "collie",
        'password_conf' => "pitbull"
      }
      response = ListMore::SignUp.run user_data
      expect(response.success?).to be_false
    end

    it "will not sign up a user when fields are missing" do
      user_data = {
        'username' => "Ramses",
        'password' => "collie"
      }
      response = ListMore::SignUp.run user_data
      expect(response.success?).to be_false
    end

    it "will not sign up a user with a missing username" do
      user_data = {
        'password' => "collie",
        'password_conf' => "collie"
      }
      response = ListMore::SignUp.run user_data
      expect(response.success?).to be_false
    end

    it "will not sign up a user multiple times" do
      user = ListMore::Entities::User.new({:username => "Ramses", :password_digest => "pitbull"})
      user = ListMore.users_repo.save user
      user_data = {
        'username' => "Ramses",
        'password' => "pitbull",
        'password_conf' => "pitbull"
      }
      response = ListMore::SignUp.run user_data
      expect(response.success?).to be_false
    end

  end

end