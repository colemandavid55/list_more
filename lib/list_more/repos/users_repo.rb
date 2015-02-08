module ListMore
  module Repositories
    class UsersRepo < RepoHelper

      def all
        result = db.exec('SELECT * FROM users').entries
        result.map{ |entry| build_user entry }
      end   

      def save user
        sql = %q[
          INSERT INTO users (username, password_digest)
          VALUES ($1, $2)
          RETURNING *
          ]
        result = db.exec(sql, [user.username, user.password_digest])
        user.id = result.first['id']
        user
      end

      def find_by_id id
        sql = %q[
          SELECT * FROM users
          WHERE id = $1
          ]
        result = db.exec(sql, [id])
        build_user result.first
      end

      def find_by_username username
        sql = %q[
          SELECT * FROM users
          WHERE username = $1
          ]
        result = db.exec(sql, [username])
        if result.first
          build_user result.first
        else
          nil
        end
      end

      def find_by_token token
        sql = %q[
                SELECT * FROM users u
                JOIN sessions s
                ON s.user_id = u.id
                WHERE s.token = $1
                ]
        result = db.exec(sql, [token])
        if result.first
          build_user result.first
        else
          nil
        end
      end

      def destroy user_data
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

