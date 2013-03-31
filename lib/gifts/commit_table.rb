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
        schema.create_table(table_name, type: :hash) do |table|
          table.reference("author", "user")
          table.time("authored_date")
          table.reference("committer", "user")
          table.time("committed_date")
          table.string("message")
          table.reference("repo")
          table.string("rev")
          table.int32("status")
        end
      end
    end

    def add(git_repo, db_repo)
      result = []

      Grit::Commit.find_all(git_repo, nil, { all: true }).each do |git_commit|
        key = db_repo.id.to_s + ":" + git_commit.id
        author = @db.users.add(git_commit.author.name)
        committer = @db.users.add(git_commit.committer.name)

        db_commit =
          table[key] ||
          table.add(
            key,
            author: author.key,
            authored_date: git_commit.authored_date,
            committer: committer.key,
            committed_date: git_commit.committed_date,
            message: git_commit.message,
            repo: db_repo.key,
            rev: git_commit.id,
            status: StatusProcessing
          )

        db_diffs = @db.diffs.add(git_commit, db_commit)

        result << db_commit
      end

      result
    end
  end
end
