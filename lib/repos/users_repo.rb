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

      def self.get_user_id db, username
        sql = %q[
          SELECT id FROM users
          WHERE username = $1
          ]
        result = db.exec(sql, [username])
        result.first['id']
      end

      def self.get_username db, user_id
        sql = %q[
          SELECT username FROM users
          WHERE id = $1
          ]
        result = db.exec(sql, [user_id])
        result.first['username']
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
    
    end
  end
end

