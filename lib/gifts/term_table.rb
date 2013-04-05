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
          default_tokenizer: "TokenBigramSplitSymbol"
        ) do |table|
          table.index("commit.message", with_position: true)

          table.index("diff.addition", with_position: true)
          table.index("diff.deletion", with_position: true)
        end
      end
    end
  end
end
