module ListMore
  module Entities    
    class User
      attr_accessor :id :username
      attr_reader: password_digest

      def initialize username, password_digest=nil id=nil
        @username = username
        @password_digest = password_digest
        @id = id
      end

      def update_password password
      end

      def has_password? password
      end
    end
  end
end