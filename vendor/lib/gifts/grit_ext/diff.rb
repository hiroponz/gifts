module Gifts::Grit
  class Diff

    def old_path
      Gifts::GritExt.encode! @a_path
    end

    def new_path
      Gifts::GritExt.encode! @b_path
    end

    def diff
      if @diff.nil?
        @diff = ""
      else
        lines = @diff.lines.to_a
        path = Gifts::GritExt.encode! lines.shift(2).join
        body = Gifts::GritExt.encode! lines.join
        @diff = path + body
      end
    end
  end
end
