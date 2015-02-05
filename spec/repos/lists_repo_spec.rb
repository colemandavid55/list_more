require 'spec_helper'
require 'pry-byebug'

describe ListMore::Repositories::ListsRepo do

  let(:db) { ListMore::Repositories.create_db_connection('listmore_test') }

  before(:each) do
    ListMore::Repositories.drop_tables db
    ListMore::Repositories.create_tables db
    ListMore::Repositories.seed_users_table db
    # usernames => 'Ramses', 'Daisy'
  end

  def list_count db
    db.exec("SELECT COUNT (*) FROM lists")[0]["count"].to_i
  end

  it "gets all lists" do
    expect(list_count db).to eq 0
    user_id_1 = ListMore::Repositories::UsersRepo.get_user_id db, 'Ramses'
    user_id_2 = ListMore::Repositories::UsersRepo.get_user_id db, 'Daisy'
    db.exec("INSERT INTO lists (name, user_id) VALUES ($1, $2)", ["Video Games", user_id_1])
    db.exec("INSERT INTO lists (name, user_id) VALUES ($1, $2)", ["Card Games", user_id_2])
    expect(list_count db).to eq 2

    lists = ListMore::Repositories::ListsRepo.all db 
    expect(lists).to be_a Array
    expect(lists.count).to eq 2
    expect(lists.count).to eq list_count db
  end

  it "saves a list to the database" do
    user_id = ListMore::Repositories::UsersRepo.get_user_id db, 'Ramses'
    list_data = {
                  :name => "Video Games",
                  :user_id => user_id
                }
    list = ListMore::Repositories::ListsRepo.save db, list_data
    expect(list['name']).to eq "Video Games"
    expect(list['user_id']).to eq user_id
  end

  it "updates the name of an existing list" do
    user_id = ListMore::Repositories::UsersRepo.get_user_id db, 'Ramses'
    list_data = {
                  :name => "Video Games",
                  :user_id => user_id
                }
    ListMore::Repositories::ListsRepo.save db, list_data
    name_new = "Video Games part 1"
    list = ListMore::Repositories::ListsRepo.update db, list_data, name_new
    expect(list['name']).to eq "Video Games part 1"
  end

end