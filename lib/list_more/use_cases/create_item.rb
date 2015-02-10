module ListMore
  class CreateItem < UseCase

    def run params
      # user = ListMore.users_repo.find_by_token params['token']

      # unless user
      #   return failure "User does not have a session id"
      # end

      item = ListMore::Entities::Item.new({:content => params['content'], :user_id => params['user_id'], :list_id => params['list_id']})
      item = ListMore.items_repo.save item

      return failure unless item

      success item: item
    end

  end
end