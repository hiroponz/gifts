module Gifts
  class FileTable < TableBase
    TypeText = 1
    TypeBinary = 2

    def table_name
      "file"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(table_name, type: :hash) do |table|
          table.string("base")
          table.string("dir")
          table.string("encoding")
          table.string("ext")
          table.reference("last_commit", "commit")
          table.reference("repo")
          table.int32("type")
        end
      end
    end

    def add(git_commit, git_diff, db_commit)
      path = git_diff.new_path
      file = git_diff.b_blob
      if file.nil? && git_commit.parents.count > 0
        path = git_diff.old_path
        file = git_diff.a_blob
      end
      return if file.nil?

      key = db_commit.repo.id.to_s + ":" + path
      return table[key] if table[key] && table[key].last_commit.committed_date > db_commit.committed_date

      base = File.basename(path)
      dir = File.dirname(path)
      ext = File.extname(path).sub(".", "")

      t =  table[key] || table.add(key, repo: db_commit.repo, base: base, dir: dir, ext: ext)
      t.last_commit = db_commit

      detection = CharlockHolmes::EncodingDetector.detect(file.data)
      if detection[:type] == :binary
        t.type = TypeBinary
      else
        t.type = TypeText
        t.encoding = detection[:encoding]
      end

      t
    end
  end
end
