require './lib/list_more'
require './server'

ListMore.users_repo = ListMore::Repositories::UsersRepo.new('listmore_test')
ListMore.lists_repo = ListMore::Repositories::ListsRepo.new('listmore_test')
ListMore.items_repo = ListMore::Repositories::ItemsRepo.new('listmore_test')
ListMore.sessions_repo = ListMore::Repositories::SessionsRepo.new('listmore_test')
ListMore.shared_lists_repo = ListMore::Repositories::SharedListsRepo.new('listmore_test')

run ListMore::Server
