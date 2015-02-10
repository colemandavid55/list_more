module ListMore
  class CreateItem < UseCase

    def run params
      user = ListMore.users_repo.find_by_token params['token']
      unless user
        return failure "User does not have a session id"
      end
      item = ListMore::Entities::Item.new({:content => params['content'], :user_id => user.id, :list_id => params['list_id']})
      if item
        return success item: item
      end
      failure
    end

  end
end