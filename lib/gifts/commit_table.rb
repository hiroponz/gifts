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

    def add(git_repo, db_repo, options = {})
      force = options.delete(:force)
      result = []

      offset = 0
      count = 100
      processed_prev_commit = false

      begin
        commits = Grit::Commit.find_all(git_repo, nil, { all: true, date_order: true, max_count: count, skip: offset })
        commits.each do |git_commit|
          key = db_repo.id.to_s + ":" + git_commit.id

          if key == db_repo.last_commit_key && !force
            processed_prev_commit = true
            break

          else
            author = @db.users.add(git_commit.author.name)
            committer = @db.users.add(git_commit.committer.name)

            db_commit =
              table[key] ||
              table.add(
                key,
                author: author,
                authored_date: git_commit.authored_date,
                committer: committer,
                committed_date: git_commit.committed_date,
                message: git_commit.message,
                repo: db_repo,
                rev: git_commit.id
              )

              db_commit.status = StatusProcessing

              db_diffs = @db.diffs.add(git_commit, db_commit)
              result << db_commit
          end
        end
        offset += count
      end until commits.count == 0 || processed_prev_commit

      result
    end
  end
end
