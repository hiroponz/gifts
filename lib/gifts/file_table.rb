module Gifts
  class FileTable < TableBase
    TypeText = 1
    TypeBinary = 2

    def table_name
      "file"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(table_name, :type => :hash) do |table|
          table.reference("repo")
          table.reference("last_commit", "commit")
          table.string("path")
          table.int32("type")
          table.string("encoding")
        end
      end
    end

    def add(git_commit, git_diff, db_commit)
      path = git_diff.new_path
      file = (git_commit.tree / path)
      if file.nil? && git_commit.parents.count > 0
        path = git_diff.old_path
        file = (git_commit.parents.first.tree / path)
      end
      return if file.nil?

      key = db_commit.repo.id.to_s + ":" + path
      return if table[key] && table[key].last_commit.committed_date > db_commit.committed_date

      t =  table[key] || table.add(key, repo: db_commit.repo.key, path: path)
      t.last_commit = db_commit.key

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
