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
          , 

        )
      SQL
    end
