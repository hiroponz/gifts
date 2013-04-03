module Gifts
  class HunkTable < TableBase
    def table_name
      "hunk"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(table_name, type: :hash) do |table|
          table.reference("diff")
          table.bool("add")
          table.int32("line_num")
          table.string("line_text")
        end
      end
    end

    def add(git_diff, db_diff)
      result = []

      # TODO: store hunk

      result
    end
  end
end
