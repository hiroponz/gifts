module Gifts::Grit
  class Actor

    alias_method :old_name, :name
    alias_method :old_email, :email

    def name
      Gifts::GritExt.encode! old_name
    end

    def email
      Gifts::GritExt.encode! old_email
    end
  end
end
