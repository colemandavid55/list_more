module ListMore
  class ListsRepo

    def self.save db, list_data
      sql = %q[INSERT INTO lists (name, user_id) VALUES ($1, $2) RETURNING *]
      result = db.exec(sql, [list_data[:name], list_data[:user_id]])
      result.first
    end

    def self.update db, list_data
      sql = %q[UPDATE lists SET name = $1 WHERE user_id = $2]
      result = db.exec(sql, [list_data[:name], list_data[:user_id]])
    end