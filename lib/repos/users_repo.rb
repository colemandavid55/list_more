module ListMore
  module Repositories
    class UsersRepo

      def self.all db
        db.exec('SELECT * FROM users').entries
      end   

      def self.save db, user_data
        sql = %q[
          INSERT INTO users (username, password)
          VALUES ($1, $2)
          RETURNING *
          ]
        result = db.exec(sql, [user_data[:username], user_data[:password]])
        result.first
      end

      def self.update
      end

      def self.delete
      end
    
    end
  end
end

