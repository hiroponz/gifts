module Gifts
  class CommitTable
    TableName = "commits"

    def self.define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(TableName, :type => :hash) do |table|
          table.reference("repositories")
          table.string("revision")
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
  end
end
