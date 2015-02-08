module ListMore
  module Repositories
    class ItemsRepo

      def self.all db
        result = db.exec('SELECT * FROM items').entries
        result.map{ |entry| build_item entry }
      end

      def self.save db, item
        sql = %q[INSERT INTO items (content, user_id, list_id) VALUES ($1, $2, $3) RETURNING *]
        result = db.exec(sql, [item.content, item.user_id, item.list_id])
        build_item result.first
      end

      def self.update db, item
        sql = %q[UPDATE items SET content = $1 WHERE user_id = $2 and list_id = $3 RETURNING *]
        result = db.exec(sql, [item.content, item.user_id, item.list_id])
        build_item result.first
      end

      def self.get_list_items db, list
        sql = %q[SELECT * FROM items
                WHERE list_id = $1
                ]
        result = db.exec(sql, [list.id])
        result.entries.map{ |entry| build_item entry }
      end

      def self.get_user_items db, user
        sql = %q[SELECT * FROM items
                WHERE user_id = $1
                ]
        result = db.exec(sql, [user.id])
        result.entries.map{ |entry| build_item entry }
      end

      def self.destroy_item db, item
        sql = %q[DELETE FROM items
                WHERE id = $1
                ]
        db.exec(sql, [item.id])
      end
      
      def build_item data
        ListMore::Entities::Item.new data
      end

    end
  end
end