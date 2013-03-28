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

    def initialize
      @table = Groonga[TableName]
    end

    def size
      @table.size
    end
  end
end
