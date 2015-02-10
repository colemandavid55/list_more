require 'spec_helper'
require 'pry-byebug'
require 'pg'

describe ListMore::Repositories::SharedListsRepo do

  let(:dbhelper) { ListMore::Repositories::DBHelper.new 'listmore_test' }
  let(:user_1) { ListMore::Entities::User.new({:username => "Ramses", :password_digest => "pitbull"})}
  let(:user_2) { ListMore::Entities::User.new({:username => "Daisy", :password_digest => "collie"})}
  

  before(:each) do
    dbhelper.drop_tables
    dbhelper.create_tables
  end

  it "saves a shared list to the database and subsequently deletes it" do
    saved_user_1 = ListMore.users_repo.save user_1
    saved_user_2 = ListMore.users_repo.save user_2


    params = {
      'name' => "Dogs",
      'user_id' => user_1.id
    }

    response = ListMore::CreateList.run params

    data = {
      'user_id' => user_2.id,
      'list_id' => response.list.id
    }
    result = ListMore.shared_lists_repo.save data

    expect(result['id'].to_i).to be_a Integer
    expect(result['user_id']).to eq user_2.id
    expect(result['list_id']).to eq response.list.id
    expect(ListMore.shared_lists_repo.all.count).to eq 1

    ListMore.shared_lists_repo.delete result['id']
    expect(ListMore.shared_lists_repo.all.count).to eq 0

  end

end