module Gifts
  class CommitTable < TableBase
    StatusProcessing = 0
    StatusCompleted = 1
    StatusTimeout = 2

    def table_name
      "commit"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(table_name, :type => :hash) do |table|
          table.reference("repo")
          table.string("rev")
          table.int32("status")
        end
      end
    end

    def add(git_repo, db_repo)
      git_repo.find_each do |git_commit|
        key = db_repo.id.to_s + ":" + git_commit.id
        db_commit = table[key] || table.add(key, repo: db_repo.key, rev: git_commit.id, status: StatusProcessing)

        @db.diffs.add(git_commit, db_commit)
      end
    end
  end
end
