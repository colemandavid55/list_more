module ListMore
  module Repositories
    class UsersRepo

      def self.all db
        db.exec('SELECT * FROM users').entries
      end   

      def self.save
      end

      def self.update
      end

      def self.delete
      end
    
    end
  end
end

