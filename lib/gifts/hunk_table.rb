module Gifts
  class HunkTable < TableBase
    def table_name
      "hunk"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(table_name, type: :hash) do |table|
          table.reference("diff")
          table.bool("add")
          table.int32("line_num")
          table.string("line_text")
        end
      end
    end

    def add(git_diff, db_diff)
      result = []

      hunk = {}
      del_pos = del_count = add_pos = add_count = add_pos = del_pos = 0
      git_diff.diff.lines do |line|
        line.chomp!

        case line[0]
        when "@"
          if del_count != del_pos || add_count != add_pos
            puts "Warning: something wrong in hunk.", git_diff.diff
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

      hunk.each do |key, value|
        value[:add] ||= []
        value[:del] ||= []

        remove = [value[:add].count, value[:del].count].min

        remove.times do |i|
          value[:add].shift
          value[:del].shift
        end

        add_db(db_diff, value, :add)
        add_db(db_diff, value, :del)
      end

      result
    end

    private

    def normalize_key(line)
      line = line[1..-1]
      line = line.strip
      line = line.gsub(/\s+/, " ")
    end

    def add_hunk(hunk, key, op, pos, line)
      unless key.empty?
        hunk[key] ||= {}
        hunk[key][op] ||= []
        hunk[key][op] << [pos, line]
      end
    end

    def add_db(db_diff, value, op)
      op_str = (op == :add ? "+" : "-")
      op_bool = (op == :add ? true : false)

      value[op].each do |item|
        line_num = item[0]
        line_text = item[1]

        hunk_key = db_diff.id.to_s + ":" + op_str + line_num.to_s
        db_hunk = table[hunk_key] || table.add(hunk_key, diff: db_diff, add: op_bool, line_num: line_num, line_text: line_text)
      end
    end
  end
end
