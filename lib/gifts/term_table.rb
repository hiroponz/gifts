module Gifts
  class TermTable < TableBase
    def table_name
      "term"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(
          table_name,
          type: :patricia_trie,
          normalizer: :NormalizerAuto,
          default_tokenizer: "TokenBigram"
        ) do |table|
          table.index("file.ext", with_position: true)
          table.index("file.path", with_position: true)

          table.index("user.name", with_position: true)
        end
      end
    end
  end
end
