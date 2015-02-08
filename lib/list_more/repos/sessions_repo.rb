module ListMore
  module Repositories
    class SessionsRepo < RepoHelper

      def save data
        sql = %q[
                INSERT INTO sessions (token, user_id)
                VALUES ($1, $2)
                RETURNING *
                ]
        result = db.exec(sql, [data[:token], data[:user_id]])
        true
      end

      def destroy token
        sql = %q[
                DELETE FROM sessions
                WHERE token = $1
                ]
        db.exec(sql, [token])
      end 

    end
  end
end


# def save user
#         sql = %q[
#           INSERT INTO users (username, password_digest)
#           VALUES ($1, $2)
#           RETURNING *
#           ]
#         result = db.exec(sql, [user.username, user.password_digest])
#         user.instance_variable_set :@id, result.first['id']
#         user
#       end