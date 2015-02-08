module ListMore
  class CreateSession < UseCase

    def run user
      token = SecureRandom.hex(16)
      ListMore.sessions_repo.save {:token => token, :user_id => user.id}
      success :token => token
    end

  end
end