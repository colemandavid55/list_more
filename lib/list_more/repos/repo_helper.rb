module ListMore
  class RepoHelper
    attr_reader :db

    def initialize dbname
      @db = PG.connect(host: 'localhost', dbname: dbname)
    end

  end
end