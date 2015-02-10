module ListMore
  module Repositories
    class SharedListsRepo < RepoHelper

      def save data
        sql = %q[
                INSERT INTO shared_lists (user_id, list_id)
                VALUES ($1, $2)
                returning *
                ]
        result = db.exec(sql, [data['user_id'], data['list_id']])
        result.first
      end

      def delete shared_list_id
        sql = %q[
                DELETE FROM shared_lists
                WHERE id = $1
                ]
        db.exec(sql, [shared_list_id])
      end

      def all
        sql = %q[
                SELECT * FROM shared_lists
                ]
        result = db.exec(sql)
        result.entries
      end

    end
  end
end