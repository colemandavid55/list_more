module ListMore
  class CreateList < UseCase
    attr_reader :params

    def run params
      @params = params
      user = ListMore.users_repo.find_by_token params['token']
      unless user
        return failure "User does not have a session id"
      end
      list = ListMore::Entities::List.new({:user_id => user.id, :name => params['name']})
      list = ListMore.lists_repo.save list
      if list
        return success list: list
      end
      failure
    end

  end
end