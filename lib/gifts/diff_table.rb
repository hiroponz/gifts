module Gifts
  class DiffTable < TableBase
    def table_name
      "diff"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(table_name, :type => :hash) do |table|
          table.reference("commit")
          table.reference("file")
          table.text("diff")
        end
      end
    end

    def add(git_commit, db_commit)
      return if db_commit.status != CommitTable::StatusProcessing

      git_commit.diffs.each do |git_diff|
        next if git_diff.diff.empty?

        path = git_diff.new_path
        file = (git_commit.tree / path)
        if file.nil?
          path = git_diff.old_path
          file = (git_commit.tree / path)
        end
        next if file.nil?
        detection = CharlockHolmes::EncodingDetector.detect(file.data)
        next if detection[:type] == :binary

        db_file = @db.files.add(path, db_commit.repo)

        key = db_commit.id.to_s + ":" + db_file.id.to_s
        table[key] || table.add(key, commit: db_commit.key, file: db_file.key, diff: diff_content(git_diff.diff))
      end
    rescue Grit::Git::GitTimeout => e
      puts "Timeout commit:#{git_commit.id}"
      db_commit.status = CommitTable::StatusTimeout
    else
      db_commit.status = CommitTable::StatusCompleted
    end

    def diff_content(diff)
      lines = diff.lines.to_a
      lines.shift(2)
      lines.join
    end
  end
end
