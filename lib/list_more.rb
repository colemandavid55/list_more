require 'ostruct'
require 'pg'
require 'bcrypt'

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

  def self.sessions_repo=(repo)
    @sessions_repo = repo
  end

  def self.sessions_repo
    @sessions_repo
  end

  def self.shared_lists_repo=(repo)
    @shared_lists_repo = repo
  end

  def self.shared_lists_repo
    @shared_lists_repo
  end
end



require_relative 'list_more/entities/item.rb'
require_relative 'list_more/entities/list.rb'
require_relative 'list_more/entities/user.rb'
require_relative 'list_more/repos/repo_helper.rb'
require_relative 'list_more/repos/users_repo.rb'
require_relative 'list_more/repos/lists_repo.rb'
require_relative 'list_more/repos/items_repo.rb'
require_relative 'list_more/repos/sessions_repo.rb'
require_relative 'list_more/repos/shared_lists_repo.rb'
require_relative 'list_more/repos/db_helper.rb'
require_relative 'list_more/use_cases/use_case.rb'
require_relative 'list_more/use_cases/signup.rb'
require_relative 'list_more/use_cases/signin.rb'
require_relative 'list_more/use_cases/create_session.rb'
require_relative 'list_more/use_cases/create_list.rb'
require_relative 'list_more/use_cases/create_item.rb'
require_relative 'list_more/use_cases/update_list.rb'
require_relative 'list_more/use_cases/update_item.rb'
require_relative 'list_more/use_cases/share_list.rb'
require_relative 'list_more/use_cases/verify_token.rb'
