module ListMore
  class RepoHelper
    attr_reader :db

    def initialize dbname
      db_data = if ENV['RACK_ENV'] == 'production'
        parse_rds_string
      else
        {host: 'localhost', dbname: dbname}
      end

      @db = PG.connect(db_data)
    end

    def parse_rds_string
      rds_string = ENV['DATABASE_URL']
      data = rds_string.split(/\/|:|@/)
      {
        host: data[5],
        port: data[6],
        user: data[3],
        password: data[4],
        dbname: data.last
      }
    end

  end
end