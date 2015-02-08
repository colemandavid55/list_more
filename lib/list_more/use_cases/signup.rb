module ListMore
  class SignUp < UseCase
    attr_reader :params

    def run params
      @params = params
      unless verify_fields
        return failure "Please check all fields"
      end
      user = ListMore.users_repo.find_by_username params['username']
      if user 
        return failure "User already exists"
      end
      user = ListMore::Entities::User.new(params)
      user.update_password params['password']
      ListMore.users_repo.save user
      response = ListMore::CreateSession.run user
      success :token => response.token
    end

    def credentials
    end

    def verify_fields
      return false if !params['username'] || params['password'] || params['password_conf']
      return false if params['password'] != params['password_conf']
      true
    end

  end
end
