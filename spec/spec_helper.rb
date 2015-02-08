require_relative '../lib/list_more.rb'

ListMore.users_repo = ListMore::Repositories::UsersRepo.new('listmore_test')
ListMore.lists_repo = ListMore::Repositories::ListsRepo.new('listmore_test')
ListMore.items_repo = ListMore::Repositories::ItemsRepo.new('listmore_test')

RSpec.configure do |config|
  config.before(:each) do
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.run_all_when_everything_filtered = true
    config.filter_run :focus
    
    config.order ='random'
  end
end

