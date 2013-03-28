module Gifts
  class RepositoryTable
    TableName = "repositories"

    def self.define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(TableName, :type => :hash) do |table|
          table.string("path")
        end
      end
    end

    def initialize(database)
      @database = database
      @table = Groonga[TableName]
    end

    def size
      @table.size
    end

    def add(path)
      repo = Repo.new(path)
      @table[path] || @table.add(path)
    end

    def remove(path)
    end
  end
end
