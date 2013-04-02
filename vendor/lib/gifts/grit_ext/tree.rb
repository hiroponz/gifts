module Gifts::Grit
  class Tree

    alias_method :old_name, :name

    def name
      Gifts::GritExt.encode! old_name
    end
  end
end
