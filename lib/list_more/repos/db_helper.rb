
module ListMore
  module Repositories
    class DBHelper < RepoHelper

      def create_tables
        db.exec <<-SQL
          CREATE TABLE IF NOT EXISTS users(
              id SERIAL PRIMARY KEY
              , username VARCHAR UNIQUE
              , password_digest VARCHAR
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
          CREATE TABLE IF NOT EXISTS shared_lists(
              id SERIAL PRIMARY KEY
              , user_id INTEGER REFERENCES users(id)
                ON DELETE CASCADE
                ON UPDATE CASCADE
              , list_id INTEGER REFERENCES lists(id)
                ON DELETE CASCADE
                ON UPDATE CASCADE
              );
          CREATE TABLE IF NOT EXISTS sessions(
              user_id INTEGER REFERENCES users(id)
                ON DELETE CASCADE
                ON UPDATE CASCADE
              , token VARCHAR
              );
          SQL
      end

      def clear_tables
        db.exec <<-SQL
          DELETE FROM users;
          DELETE FROM lists;
          DELETE FROM shared_lists;
          DELETE FROM items;
          DELETE FROM sessions;
        SQL
      end

      def drop_tables
        db.exec <<-SQL
          DROP TABLE users CASCADE;
          DROP TABLE lists CASCADE;
          DROP TABLE shared_lists CASCADE;
          DROP TABLE items CASCADE;
          DROP TABLE sessions CASCADE;
        SQL
      end

      def seed_users_table
        db.exec("INSERT INTO users (username, password) VALUES ($1, $2)", ["Ramses", "pitbull"])
        db.exec("INSERT INTO users (username, password) VALUES ($1, $2)", ["Daisy", "collie"])
      end
    end

  end
end

