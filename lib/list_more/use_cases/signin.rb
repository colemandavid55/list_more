module ListMore
  class SignIn < UseCase
    attr_reader :params

    def run params
      @params = params

      unless verify_fields
        return failure "Please check all fields"
      end

      user = ListMore.users_repo.find_by_username(params['username'])

      unless user 
        return failure "User not found"
      end

      if user.has_password? params['password']
        created_session = ListMore::CreateSession.run user
      else
        return failure "Incorrect Password"
      end

      success :token => created_session.token, :user => user
    end

    def verify_fields
      return false if !(params['username'] && params['password'])
      true
    end

  end
end