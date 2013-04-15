module Gifts
  class TermSplitSymbolAlphaTable < TableBase
    def table_name
      "term_split_symbol_alpha"
    end

    def define_schema
      Groonga::Schema.define do |schema|
        schema.create_table(
          table_name,
          type: :patricia_trie,
          normalizer: :NormalizerAuto,
          default_tokenizer: "TokenBigramSplitSymbolAlpha"
        ) do |table|
          table.index("commit.message", with_position: true)

          table.index("diff.diff", with_position: true)
        end
      end
    end
  end
end
