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
          table.text("addition")
          table.text("deletion")
        end
      end
    end

    def add(git_commit, db_commit)
      if db_commit.status == CommitTable::StatusProcessing
        result = []

        begin
          git_commit.diffs.each do |git_diff|
            next if git_diff.diff.nil?

            db_file = @db.files.add(git_commit, git_diff, db_commit)

            if db_file && db_file.type == FileTable::TypeText
              key = db_commit.id.to_s + ":" + db_file.id.to_s
              addition, deletion = separete_diff(git_diff.diff)

              db_diff =
                table[key] ||
                table.add(
                  key,
                  commit: db_commit,
                  file: db_file,
                  addition: addition,
                  deletion: deletion
                )

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

    private

    def separete_diff(diff)
      hunk = {}

      diff.lines do |line|
        line.chomp!

        case line[0]
        when "+"
          key = normalize_key(line)
          add_hunk(hunk, key, +1)
        when "-"
          key = normalize_key(line)
          add_hunk(hunk, key, -1)
        end
      end

      additions = []
      deletions = []
      hunk.each do |key, value|
        if value > 0
          additions << key
        elsif value < 0
          deletions << key
        end
      end

      [additions.join("\n"), deletions.join("\n")]
    end

    def normalize_key(line)
      # remove "+" or "-" symbol
      line = line[1..-1]
      # remove head and trail spaces
      line = line.strip
      # compact spaces
      line = line.gsub(/\s+/, " ")
    end

    def add_hunk(hunk, key, value)
      unless key.empty?
        hunk[key] ||= 0
        hunk[key] += value
      end
    end
  end
end
