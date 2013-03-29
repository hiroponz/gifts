module Gifts
  class FileTable < TableBase
    def table_name
      "file"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(table_name, :type => :hash) do |table|
          table.reference("repo")
          table.string("path")
        end
      end
    end

    def add(path, db_repo)
      if path
        key = db_repo.id.to_s + ":" + path
        table[key] || table.add(key, repo: db_repo.key, path: path)
      end
    end
  end
end
