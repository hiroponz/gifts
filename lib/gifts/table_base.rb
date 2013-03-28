module Gifts
  class TableBase < SimpleDelegator
    attr_reader :db

    def initialize(database)
      @db = database
      super(Groonga[table_name])
      define_schema
    end
  end
end
