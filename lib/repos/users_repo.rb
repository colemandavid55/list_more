module ListMore
  module Repositories
    class UsersRepo

      def self.all db
        result = db.exec('SELECT * FROM users').entries
        result.map{ |entry| build_user entry }
      end   

      def self.save db, user_data
        sql = %q[
          INSERT INTO users (username, password)
          VALUES ($1, $2)
          RETURNING *
          ]
        result = db.exec(sql, [user_data[:username], user_data[:password]])
        build_user result.first
      end

      def self.get_user_by_id db, id
        sql = %q[
          SELECT * FROM users
          WHERE id = $1
          ]
        result = db.exec(sql, [id])
        build_user result.first
      end

      def self.get_user_by_username db, username
        sql = %q[
          SELECT * FROM users
          WHERE username = $1
          ]
        result = db.exec(sql, [username])
        build_user result.first
      end

      def self.destroy db, user_data
        sql, param = user_data['id'] ?
          [%q[
            DELETE FROM users
            WHERE id = $1
            ],
          user_data['id']]
          :
          [%q[
            DELETE FROM users
            WHERE username = $1
            ],
          user_data['username']]
          db.exec(sql, [param])
      end

      def build_user data
        ListMore::Entities::User.new data
      end
    
    end
  end
end

