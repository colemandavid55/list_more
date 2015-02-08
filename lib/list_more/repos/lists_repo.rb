module ListMore
  module Repositories
    class ListsRepo

      def all
        result = db.exec('SELECT * FROM lists').entries
        result.map{ |entry| build_list entry }
      end 

      def save list
        sql = %q[INSERT INTO lists (name, user_id) VALUES ($1, $2) RETURNING *]
        result = db.exec(sql, [list.name, list.user_id])
        build_list result.first
      end

      def update list
        sql = %q[UPDATE lists SET name = $1 WHERE id = $2 RETURNING *]
        result = db.exec(sql, [list.name, list.id])
        build_list result.first
      end

      # def get_list_id list_name
      #   sql = %q[SELECT id FROM lists WHERE name = $1]
      #   result = db.exec(sql, [list_name])
      #   result.first['id']
      #   # empty array could be returned here, check if something was found
      # end

      # def share_list other_user_id, list_id
      #   sql = %q[INSERT INTO shared_lists (user_id, list_id) VALUES ($1, $2) RETURNING *]
      #   result = db.exec(sql, [other_user_id, list_id])
      #   result.first
      # end

      # Make sure there is some verification of contents, array could be empty result.first is a good example
      def get_user_lists user
        sql = %q[SELECT * FROM lists
                WHERE user_id = $1
                ]
        result = db.exec(sql, [user.id])
        result.entries.map{ |entry| build_list entry }
      end

      def get_user_shared_lists user_id
      end

      def destroy_list list
        sql = %q[DELETE FROM lists
                WHERE id = $1
                ]
        db.exec(sql, [list.id])
      end

      def build_list data
        ListMore::Entities::List.new data
      end

    end
  end
end

# Notes for repos from nick, have methods to get entire profile based on id or username, return entire user object
# Did i get anything with my methods
# Entity pattern in ruby: build a user/list/item object
# Make a class for user => attr_accessor :id :username, attr_reader :password
#  Within lib directory, we want a entities folder with this class within 
#  class User : def init (username, password, id=mil) : def has_password? (string_password) code would be whatever bcrypt needs to do to verify password, return true
# within server.rb user = URepo.find_by_username(username); if user.has_password?(params[:password]) then do all the login stuff else return an error of some sort
# 