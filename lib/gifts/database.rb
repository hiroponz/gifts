module Gifts
  class Database
    def self.open(filename)
      if File.exist?(filename)
        database = Groonga::Database.open(filename)
      else
        FileUtils.mkdir_p(File.dirname filename)
        database = Groonga::Database.create(path: filename)
      end

      database = Database.new(database)

      if block_given?
        begin
          yield database
        ensure
          database.close
        end
      else
        database
      end
    end

    def initialize(database)
      @database = database
      @repositories = nil
      @commits = nil

      define_schema
    end

    def close
      unless closed?
        @database.close
        @database = nil
      end
    end

    def closed?
      @database.nil? or @database.closed?
    end

    def repositories
      @repositories ||= RepositoryTable.new(self)
    end

    def commits
      @commits ||= CommitTable.new(self)
    end

    private
    def define_schema
      RepositoryTable.define_schema
      CommitTable.define_schema
    end
  end
end
