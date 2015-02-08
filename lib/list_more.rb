require 'ostruct'
require 'pg'

module ListMore
  def self.users_repo=(repo)
    @users_repo = repo
  end
  def self.users_repo
    @users_repo
  end

  def self.lists_repo=(repo)
    @lists_repo = repo
  end

  def self.lists_repo
    @lists_repo
  end

  def self.items_repo=(repo)
    @items_repo = repo
  end

  def self.items_repo
    @items_repo
  end
end



require_relative 'list_more/entities/item.rb'
require_relative 'list_more/entities/list.rb'
require_relative 'list_more/entities/user.rb'
require_relative 'list_more/repos/repo_helper.rb'
require_relative 'list_more/repos/users_repo.rb'
require_relative 'list_more/repos/lists_repo.rb'
require_relative 'list_more/repos/items_repo.rb'
require_relative 'list_more/repos/db_helper.rb'
