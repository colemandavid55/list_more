module ListMore
  module Repositories
    class ListsRepo

      def self.all db
        result = db.exec('SELECT * FROM lists').entries
        result.map{ |entry| build_list entry }
      end 

      def self.save db, list_data
        sql = %q[INSERT INTO lists (name, user_id) VALUES ($1, $2) RETURNING *]
        result = db.exec(sql, [list_data[:name], list_data[:user_id]])
        build_list result.first
      end

      def self.update db, list_data, name_new
        sql = %q[UPDATE lists SET name = $1 WHERE user_id = $2 and name = $3 RETURNING *]
        result = db.exec(sql, [name_new, list_data[:user_id], list_data[:name]])
        build_list result.first
      end

      # def self.get_list_id db, list_name
      #   sql = %q[SELECT id FROM lists WHERE name = $1]
      #   result = db.exec(sql, [list_name])
      #   result.first['id']
      #   # empty array could be returned here, check if something was found
      # end

      # def self.share_list db, other_user_id, list_id
      #   sql = %q[INSERT INTO shared_lists (user_id, list_id) VALUES ($1, $2) RETURNING *]
      #   result = db.exec(sql, [other_user_id, list_id])
      #   result.first
      # end

      # Make sure there is some verification of contents, array could be empty result.first is a good example
      def self.get_user_lists db, user
        sql = %q[SELECT * FROM lists
                WHERE user_id = $1
                ]
        result = db.exec(sql, [user.id])
        result.entries.map{ |entry| build_list entry }
      end

      def self.get_user_shared_lists db, user_id
      end

      def self.destroy_list db, list
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