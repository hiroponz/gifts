module Gifts
  class RepoTable < TableBase
    def table_name
      "repo"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(table_name, type: :hash) do |table|
          table.string("path")
        end
      end
    end

    def add(path)
      git_repo = Repo.new(path)

      db_repo = table[path] || table.add(path, path: path)

      @db.commits.add(git_repo, db_repo)
    end

    def remove(path)
    end
  end
end
