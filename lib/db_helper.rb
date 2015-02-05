require 'pg'

module ListMore
  module Repositories

      def self.create_db_connection dbname
        PG.connect(host: 'localhost', dbname: dbname)
      end

      def self.create_tables db
        db.exec <<-SQL
          CREATE TABLE IF NOT EXISTS users(
              id SERIAL PRIMARY KEY
              , username VARCHAR UNIQUE
              , password VARCHAR
              );
          CREATE TABLE IF NOT EXISTS lists(
              id SERIAL PRIMARY KEY
              , name VARCHAR UNIQUE
              , user_id INTEGER REFERENCES users(id)
                ON DELETE CASCADE
                ON UPDATE CASCADE
              );
          CREATE TABLE IF NOT EXISTS items(
              id SERIAL PRIMARY KEY
              , content TEXT
              , user_id INTEGER REFERENCES users(id)
                ON DELETE CASCADE
                ON UPDATE CASCADE
              , list_id INTEGER REFERENCES lists(id)
                ON DELETE CASCADE
                ON UPDATE CASCADE
              );
          SQL
      end

      def self.clear_tables db
        db.exec <<-SQL
          DELETE FROM users;
          DELETE FROM lists;
          DELETE FROM items;
        SQL
      end

      def self.drop_tables db
        db.exec <<-SQL
          DROP TABLE items;
          DROP TABLE lists;
          DROP TABLE users;
        SQL
      end

      def self.seed_users_table db
        db.exec("INSERT INTO users (username, password) VALUES ($1, $2)", ["Ramses", "pitbull"])
        db.exec("INSERT INTO users (username, password) VALUES ($1, $2)", ["Daisy", "collie"])
      end

  end
end

require_relative 'repos/users_repo'
require_relative 'repos/lists_repo'
