module Gifts
  class TermTable < TableBase
    def table_name
      "term"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(
          "term",
          type: :patricia_trie,
          normalizer: :NormalizerAuto,
          default_tokenizer: "TokenBigram"
        ) do |table|
          table.index("commit.message", with_position: true)

          table.index("diff.diff", with_position: true)

          table.index("file.ext", with_position: true)
          table.index("file.path", with_position: true)

          table.index("user.name", with_position: true)
        end
      end
    end
  end
end
