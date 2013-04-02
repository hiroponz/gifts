module Gifts::Grit
  class Commit

    alias_method :old_message, :message
    alias_method :old_short_message, :short_message

    def message
      Gifts::GritExt.encode! old_message
    end

    def short_message
      Gifts::GritExt.encode! old_short_message
    end
  end
end
