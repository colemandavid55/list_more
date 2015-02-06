module ListMore
  module Repositories
    class ListsRepo

      def self.all db
        db.exec('SELECT * FROM lists').entries
      end 

      def self.save db, list_data
        sql = %q[INSERT INTO lists (name, user_id) VALUES ($1, $2) RETURNING *]
        result = db.exec(sql, [list_data[:name], list_data[:user_id]])
        result.first
      end

      def self.update db, list_data, name_new
        sql = %q[UPDATE lists SET name = $1 WHERE user_id = $2 and name = $3 RETURNING *]
        result = db.exec(sql, [name_new, list_data[:user_id], list_data[:name]])
        result.first
      end

      def self.get_list_id db, list_name
        sql = %q[SELECT id FROM lists WHERE name = $1]
        result = db.exec(sql, [list_name])
        result.first['id']
      end

      def self.share_list db, other_user_id, list_id
        sql = %q[INSERT INTO shared_lists (user_id, list_id) VALUES ($1, $2) RETURNING *]
        result = db.exec(sql, [other_user_id, list_id])
        result.first
      end

      def self.get_user_owner_lists db, user_id
        sql = %q[SELECT * FROM lists
                WHERE user_id = $1
                ]
        result = db.exec(sql, [user_id])
        result.entries
      end

      def self.destroy_list db, user_id, list_id
      end

    end
  end
end
