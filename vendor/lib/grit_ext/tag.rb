module Gifts::Grit
  class Tag

    alias_method :old_message, :message

    def message
      Gifts::GritExt.encode! old_message
    end
  end
end
