module Gifts
  class TableBase
    extend Forwardable

    def_delegators :@table, :records, :size

    def initialize(database)
      @db = database
      @table = Groonga[table_name]
      define_schema
    end
  end
end
