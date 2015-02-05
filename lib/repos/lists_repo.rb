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

    end
  end
end
