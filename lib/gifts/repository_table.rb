module Gifts
  class RepositoryTable < TableBase
    def initialize(database)
      super(database)
    end

    def table_name
      "repositories"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(table_name, :type => :hash) do |table|
          table.string("path")
        end
      end
    end

    def add(path)
      repo = Repo.new(path)
      self[path] || super(path)
    end

    def remove(path)
    end
  end
end
