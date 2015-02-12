require 'spec_helper'
require 'pry-byebug'
require 'pg'

describe ListMore::Repositories::ListsRepo do

  let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }
  let(:user_1) { ListMore::Entities::User.new({:username => "Ramses", :password_digest => "pitbull"})}
  let(:user_2) { ListMore::Entities::User.new({:username => "Daisy", :password_digest => "collie"})}
  

  before(:each) do
    dbhelper.drop_tables
    dbhelper.create_tables
  end

  it "saves a list to the database" do

    user = ListMore.users_repo.save user_1
    list_1 = ListMore::Entities::List.new({:name => "First List", :user_id => user.id})


    list = ListMore.lists_repo.save list_1

    expect(list.name).to eq "First List"
    expect(list.user_id).to eq "1"
    expect(list.user_id.to_i).to be_a Integer
    expect(list.id.to_i).to be_a Integer
  end

  it "gets all lists" do
    user = ListMore.users_repo.save user_1
    list_1 = ListMore::Entities::List.new({:name => "First List", :user_id => user.id})
    list_2 = ListMore::Entities::List.new({:name => "Second List", :user_id => user.id})

    ListMore.lists_repo.save list_1
    ListMore.lists_repo.save list_2

    lists = ListMore.lists_repo.all
    expect(lists).to be_a Array
    expect(lists.count).to eq 2
  end


  it "updates an existing list" do
    user = ListMore.users_repo.save user_1
    list_1 = ListMore::Entities::List.new({:name => "First List", :user_id => user.id})
    saved_list = ListMore.lists_repo.save list_1
    saved_list.name = "Second List"

    list_updated = ListMore.lists_repo.update saved_list
    expect(list_updated.name).to eq "Second List"
  end

  it "gets a user's lists" do
    user = ListMore.users_repo.save user_1
    list_1 = ListMore::Entities::List.new({:name => "First List", :user_id => user.id})
    list_2 = ListMore::Entities::List.new({:name => "Second List", :user_id => user.id})
    ListMore.lists_repo.save list_1
    ListMore.lists_repo.save list_2
    lists = ListMore.lists_repo.get_user_lists user.id

    expect(lists).to be_a Array
    expect(lists.count).to eq 2
    expect(lists.map{|list| list.name}).to include "First List", "Second List"
  end

  it "destroys a list" do
    user = ListMore.users_repo.save user_1
    list_1 = ListMore::Entities::List.new({:name => "First List", :user_id => user.id})
    list = ListMore.lists_repo.save list_1
    ListMore.lists_repo.destroy_list list
    result = ListMore.lists_repo.all
    expect(result).to eq []
  end

end