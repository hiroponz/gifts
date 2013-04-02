module Gifts
  class TableBase
    extend Forwardable

    def_delegators :table, :count, :records, :select, :size

    def initialize(database)
      @db = database
      define_schema
    end

    protected

    def table
      Groonga[table_name]
    end
  end
end
