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
          table.text("diff")
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
              db_diff =
                table[key] ||
                table.add(
                  key,
                  commit: db_commit,
                  file: db_file,
                  diff: compact_diff(git_diff.diff)
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

    def compact_diff(diff)
      hunk = {}
      del_pos = del_count = add_pos = add_count = add_pos = del_pos = 0

      diff.lines do |line|
        line.chomp!

        case line[0]
        when "@"
          if del_count != del_pos || add_count != add_pos
            puts "Warning: something wrong in hunk.", line, diff
          end
          m = line.match(/@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@/)
          del_start = m[1].to_i
          del_count = m[2].to_i || 0
          add_start = m[3].to_i
          add_count = m[4].to_i || 0
          del_pos = add_pos = 0
        when "+"
          add_pos += 1
          key = normalize_key(line)
          add_hunk(hunk, key, :add, add_pos, line)
        when "-"
          del_pos += 1
          key = normalize_key(line)
          add_hunk(hunk, key, :del, del_pos, line)
        else
          del_pos += 1
          add_pos += 1
        end
      end

      lines = []
      hunk.each do |key, value|
        value[:add] ||= []
        value[:del] ||= []

        remove = [value[:add].count, value[:del].count].min

        remove.times do |i|
          value[:add].shift
          value[:del].shift
        end

        lines << ("+" + value[:add].join(",") + " " + key) if value[:add].count > 0
        lines << ("-" + value[:del].join(",") + " " + key) if value[:del].count > 0
      end

      lines.join("\n")
    end


    def normalize_key(line)
      line = line[1..-1]
      line = line.strip
      line = line.gsub(/\s+/, " ")
    end

    def add_hunk(hunk, key, op, pos, line)
      unless key.empty?
        hunk[key] ||= {}
        hunk[key][op] ||= []
        hunk[key][op] << pos
      end
    end
  end
end
