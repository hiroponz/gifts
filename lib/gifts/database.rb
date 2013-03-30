module Gifts
  class Database
    attr_reader :repos, :commits, :files, :diffs, :terms

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
      @repos = RepoTable.new(self)
      @commits = CommitTable.new(self)
      @files = FileTable.new(self)
      @diffs = DiffTable.new(self)
      @terms = TermTable.new(self)
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
  end
end
