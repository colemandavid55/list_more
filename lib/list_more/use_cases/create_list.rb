module ListMore
  class CreateList < UseCase

    def run params
      user = ListMore.users_repo.find_by_token params['token']
      unless user
        return failure "User does not have a session id"
      end
      list = ListMore::Entities::List.new({:user_id => user.id, :name => params['name']})
      ListMore.lists_repo.save list
      success
    end

  end
end