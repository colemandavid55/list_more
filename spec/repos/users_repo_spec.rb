require 'spec_helper'

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



end
