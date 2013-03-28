module Gifts
  class CommitTable < TableBase
    def initialize(database)
      super(database)
    end

    def table_name
      "commits"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(table_name, :type => :hash) do |table|
          table.reference("repositories")
          table.string("revision")
        end
      end
    end
  end
end
