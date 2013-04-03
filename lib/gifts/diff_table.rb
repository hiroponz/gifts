module Gifts
  class DiffTable < TableBase
    def table_name
      "diff"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(table_name, type: :hash) do |table|
          table.reference("commit")
          table.reference("file")
        end
      end
    end

    def add(git_commit, db_commit)
      result = []

      begin
        git_commit.diffs.each do |git_diff|
          next if git_diff.diff.nil?

          db_file = @db.files.add(git_commit, git_diff, db_commit)

          if db_file && db_file.type == FileTable::TypeText
            key = db_commit.id.to_s + ":" + db_file.id.to_s
            db_diff =
              table[key] ||
              table.add(
                key,
                commit: db_commit,
                file: db_file
              )

            db_hunks = @db.hunks.add(git_diff, db_diff)

            result << db_diff
          end
        end
      rescue Grit::Git::GitTimeout => e
        puts "Timeout commit:#{git_commit.id}"
        db_commit.status = CommitTable::StatusTimeout
      else
        db_commit.status = CommitTable::StatusCompleted
      end

      result
    else
      records = table.select do |record|
        record.commit == db_commit
      end
    end
  end
end
