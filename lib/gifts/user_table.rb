module Gifts
  class UserTable < TableBase
    def table_name
      "user"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(table_name, type: :hash) do |table|
          table.string("name")
        end
      end
    end

    def add(name)
      db_user = table[name] || table.add(name, name: name)
    end
  end
end
