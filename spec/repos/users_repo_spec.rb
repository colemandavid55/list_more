require 'spec_helper'
require 'pry-byebug'

describe ListMore::Repositories::UsersRepo do

  let(:db) { ListMore::Repositories.create_db_connection('listmore_test') }

  before(:each) do
    ListMore::Repositories.drop_tables db
    ListMore::Repositories.create_tables db
  end

  def user_count(db) 
    db.exec("SELECT COUNT (*) FROM users")[0]["count"].to_i
  end

  it "gets all users" do
    db.exec("INSERT INTO users (username, password) VALUES ($1, $2)", ["Ramses", "pitbull"])
    db.exec("INSERT INTO users (username, password) VALUES ($1, $2)", ["Daisy", "collie"])

    users = ListMore::Repositories::UsersRepo.all db
    expect(users).to be_a Array
    expect(users.count).to eq 2
    expect(users.count).to eq user_count db
  end

  it "saves a user to the database" do
    user_data = {
                  :username => "Ramses",
                  :password => "pitbull"
                }
    user = ListMore::Repositories::UsersRepo.save db, user_data

    expect(user['username']).to eq "Ramses"
    expect(user['password']).to eq "pitbull"
    expect(user['id'].to_i).to be_a Integer
  end

  it "can find a user's id by username" do
    user = ListMore::Repositories::UsersRepo.save db, {:username => "Ozymandias", :password => "egypt"}
    user_id = ListMore::Repositories::UsersRepo.get_user_id db, user['username']

    expect(user_id).to eq user['id']
  end

  it "can find a username by id" do
    user = ListMore::Repositories::UsersRepo.save db, {:username => "Ozymandias", :password => "egypt"}
    username = ListMore::Repositories::UsersRepo.get_username db, user['id']

    expect(username).to eq user['username']
    expect(username).to eq "Ozymandias"
  end

  it "can delete a user by username" do
    expect(user_count db).to eq 0
    user = ListMore::Repositories::UsersRepo.save db, {:username => "Ozymandias", :password => "egypt"}
    expect(user_count db).to eq 1

    ListMore::Repositories::UsersRepo.destroy db, {"username" => "Ozymandias"}
    expect(user_count db).to eq 0
  end

  it "can delete a user by id" do
    expect(user_count db).to eq 0
    user = ListMore::Repositories::UsersRepo.save db, {:username => "Ozymandias", :password => "egypt"}
    expect(user_count db).to eq 1

    ListMore::Repositories::UsersRepo.destroy db, {"id" => user['id']}
    expect(user_count db).to eq 0
  end

end
