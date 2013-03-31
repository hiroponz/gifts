module Gifts::Grit
  class Blob

    alias_method :old_name, :name
    alias_method :old_data, :data

    def name
      Gifts::GritExt.encode! old_name
    end

    def data
      Gifts::GritExt.encode! old_data
    end

    class << self
      alias_method :old_blame, :blame

      def blame(repo, commit, file)
        old_blame(repo, commit, file).map do |b,lines|
          [b, Gifts::GritExt.encode!(lines.join('\n')).split('\n')]
        end
      end
    end

  end
end
