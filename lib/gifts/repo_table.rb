module Gifts
  class RepoTable < TableBase
    def table_name
      "repo"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(table_name, type: :hash) do |table|
          table.string("path")
          table.string("last_commit_key")
        end
      end
    end

    def add(path, options = {})
      path  = File.expand_path(path)

      git_repo = Grit::Repo.new(path)
      db_repo = table[path] || table.add(path, path: path)

      db_commits = @db.commits.add(git_repo, db_repo, options)

      # update last commit key
      db_repo.last_commit_key = db_commits.first.key if db_commits.count > 0

      db_repo
    end
  end
end
