module ListMore
  class VerifyToken < UseCase

    def run params
      user = ListMore.users_repo.find_by_token params['token']

      if user
        params.merge!('user_id' => user.id) unless params['user_id']
        true
      else
        false
      end
    end

  end
end
