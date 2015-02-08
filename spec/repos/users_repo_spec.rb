require 'spec_helper'
require 'pry-byebug'

describe ListMore::Repositories::UsersRepo do

  let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }
  let(:user_1) { ListMore::Entities::User.new({:username => "Ramses", :password_digest => "pitbull"})}
  let(:user_2) { ListMore::Entities::User.new({:username => "Daisy", :password_digest => "collie"})}

  before(:each) do
    dbhelper.drop_tables 
    dbhelper.create_tables 
  end


  it "saves a user to the database" do

    result = ListMore.users_repo.save user_1

    expect(result.username).to eq "Ramses"
    expect(result.password_digest).to eq "pitbull"
    expect(result.id.to_i).to be_a Integer
  end

  it "gets all users" do
    ListMore.users_repo.save user_1
    ListMore.users_repo.save user_2

    users = ListMore.users_repo.all
    expect(users).to be_a Array
    expect(users.count).to eq 2
  end

  it "gets a user by id" do
    user = ListMore.users_repo.save user_1
    result = ListMore.users_repo.find_by_id user.id
    expect(result).to be_a ListMore::Entities::User
  end

  it "gets a user by username" do
    user = ListMore.users_repo.save user_1
    result = ListMore.users_repo.find_by_username user.username
    expect(result).to be_a ListMore::Entities::User
  end  

  xit "can delete a user by username" do
    expect(user_count db).to eq 0
    user = ListMore::Repositories::UsersRepo.save db, {:username => "Ozymandias", :password => "egypt"}
    expect(user_count db).to eq 1

    ListMore::Repositories::UsersRepo.destroy db, {"username" => "Ozymandias"}
    expect(user_count db).to eq 0
  end

  xit "can delete a user by id" do
    expect(user_count db).to eq 0
    user = ListMore::Repositories::UsersRepo.save db, {:username => "Ozymandias", :password => "egypt"}
    expect(user_count db).to eq 1

    ListMore::Repositories::UsersRepo.destroy db, {"id" => user['id']}
    expect(user_count db).to eq 0
  end

end
