require 'spec_helper'
require 'pry-byebug'
require 'pg'

describe ListMore::Repositories::ItemsRepo do

  let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }
  let(:user_1) { ListMore::Entities::User.new({:username => "Ramses", :password_digest => "pitbull"})}
  let(:user_2) { ListMore::Entities::User.new({:username => "Daisy", :password_digest => "collie"})}

  before(:each) do
    dbhelper.drop_tables
    dbhelper.create_tables
  end

  it "saves an item to the database" do

    user = ListMore.users_repo.save user_1
    list_1 = ListMore::Entities::List.new({:name => "First List", :user_id => user.id})
    list = ListMore.lists_repo.save list_1

    item_1 = ListMore::Entities::Item.new({:content => "Here is some content", :user_id => user.id, :list_id => list.id})
    item = ListMore.items_repo.save item_1

    expect(item.content).to eq "Here is some content"
    expect(item.user_id).to eq "1"
    expect(item.user_id.to_i).to be_a Integer
    expect(item.list_id).to eq "1"
    expect(item.list_id.to_i).to be_a Integer
    expect(item.id.to_i).to be_a Integer
  end 

  it "gets all  items in the databse" do
    user = ListMore.users_repo.save user_1
    list_1 = ListMore::Entities::List.new({:name => "First List", :user_id => user.id})
    list = ListMore.lists_repo.save list_1

    item_1 = ListMore::Entities::Item.new({:content => "Here is some content", :user_id => user.id, :list_id => list.id})
    item_2 = ListMore::Entities::Item.new({:content => "More content", :user_id => user.id, :list_id => list.id})
    ListMore.items_repo.save item_1
    ListMore.items_repo.save item_2

    items = ListMore.items_repo.all
    expect(items).to be_a Array
    expect(items.map{ |item| item.content }).to include "Here is some content", "More content"
  end 

  it "updates content of existing item" do
    user = ListMore.users_repo.save user_1
    list_1 = ListMore::Entities::List.new({:name => "First List", :user_id => user.id})
    list = ListMore.lists_repo.save list_1
    item_1 = ListMore::Entities::Item.new({:content => "Here is some content", :user_id => user.id, :list_id => list.id})
    saved_item = ListMore.items_repo.save item_1

    saved_item.content = "Updated Content"

    item_updated = ListMore.items_repo.update saved_item
    expect(item_updated.content).to eq "Updated Content"
  end

  it "gets all items of a list" do
    user = ListMore.users_repo.save user_1
    list_1 = ListMore::Entities::List.new({:name => "First List", :user_id => user.id})
    list = ListMore.lists_repo.save list_1
    item_1 = ListMore::Entities::Item.new({:content => "Here is some content", :user_id => user.id, :list_id => list.id})
    ListMore.items_repo.save item_1
    item_2 = ListMore::Entities::Item.new({:content => "More content", :user_id => user.id, :list_id => list.id})
    ListMore.items_repo.save item_2
    items = ListMore.items_repo.get_list_items list
    expect(items).to be_a Array
    expect(items.count).to be 2
    expect(items.map{|item| item.content}).to include "Here is some content", "More content"
  end

  it "gets all items of a user" do
    user = ListMore.users_repo.save user_1
    list_1 = ListMore::Entities::List.new({:name => "First List", :user_id => user.id})
    list_2 = ListMore::Entities::List.new({:name => "Second List", :user_id => user.id})
    ListMore.lists_repo.save list_1
    ListMore.lists_repo.save list_2

    item_1 = ListMore::Entities::Item.new({:content => "Here is some content", :user_id => user.id, :list_id => list_1.id})
    item_2 = ListMore::Entities::Item.new({:content => "More content", :user_id => user.id, :list_id => list_2.id})
    [item_1, item_2].each{|item| ListMore.items_repo.save item }
    items = ListMore.items_repo.get_user_items user

    expect(items).to be_a Array
    expect(items.count).to be 2
    expect(items.map{|item| item.content}).to include "Here is some content", "More content"
  end

  it "destroys an item" do
    user = ListMore.users_repo.save user_1
    list_1 = ListMore::Entities::List.new({:name => "First List", :user_id => user.id})
    list = ListMore.lists_repo.save list_1
    item_1 = ListMore::Entities::Item.new({:content => "Here is some content", :user_id => user.id, :list_id => list.id})
    item = ListMore.items_repo.save item_1

    ListMore.items_repo.destroy_item item
    item_test = ListMore.items_repo.all
    expect(item_test).to eq []

  end
end