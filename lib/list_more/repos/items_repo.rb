module ListMore
  module Repositories
    class ItemsRepo < RepoHelper

      def all
        result = db.exec('SELECT * FROM items').entries
        result.map{ |entry| build_item entry }
      end

      def save item
        sql = %q[INSERT INTO items (content, user_id, list_id) VALUES ($1, $2, $3) RETURNING *]
        result = db.exec(sql, [item.content, item.user_id, item.list_id])
        build_item result.first
      end

      def update item
        sql = %q[UPDATE items SET content = $1 WHERE user_id = $2 and list_id = $3 and id = $4 RETURNING *]
        result = db.exec(sql, [item.content, item.user_id, item.list_id, item.id])
        build_item result.first
      end

      def find_by_id item_id
        result = db.exec("SELECT * FROM items WHERE id = $1;", [item_id])
        build_item result.first
      end

      def get_list_items list_id
        sql = %q[SELECT * FROM items
                WHERE list_id = $1
                ]
        result = db.exec(sql, [list_id])
        result.entries.map{ |entry| build_item entry }
      end

      def get_user_items user
        sql = %q[SELECT * FROM items
                WHERE user_id = $1
                ]
        result = db.exec(sql, [user.id])
        result.entries.map{ |entry| build_item entry }
      end

      def destroy_item item_id
        sql = %q[DELETE FROM items
                WHERE id = $1
                ]
        db.exec(sql, [item_id])
      end
      
      def build_item data
        ListMore::Entities::Item.new data
      end

    end
  end
end