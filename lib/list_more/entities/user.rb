module ListMore
  module Entities    
    class User < OpenStruct

      def update_password password
        self.password_digest = BCrypt::Password.create(password)
      end

      def has_password? password
        # require 'pry-byebug'; binding.pry
        x = BCrypt::Password.new(self.password_digest)
        x == password
      end
      
    end
  end
end