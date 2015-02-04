require 'pg'

module ListMore

  def self.create_db_connection dbname
    PG.connect(host: 'localhost', dbname: dbname)
  end

  def self.create_tables db
    db.exec <<-SQL
      CREATE TABLE IF NOT EXISTS users(
          id SERIAL PRIMARY KEY
          , username VARCHAR
          , password VARCHAR
          );
      CREATE TABLE IF NOT EXISTS lists(
          id SERIAL PRIMARY KEY
          , name VARCHAR
          , user_id REFERENCES users(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
          );
      CREATE TABLE IF NOT EXISTS items(
          id SERIAL PRIMARY KEY
          , content TEXT
          , user_id REFERENCES users(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
          , list_id REFERENCES lists(id)
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
        DROP TABLE ;
        DROP TABLE ;
        DROP TABLE ;
      SQL
    end

    def self.seed_tables db
      db.exec <<-SQL

      SQL
    end
