module Gifts
  class Repo < SimpleDelegator
    def initialize(path)
      super(Grit::Repo.new(path))
    end

    def find_each
      max_count = 1000
      offset = 0
      completed = false

      until completed
        commits = Grit::Commit.find_all(self, nil, {all: true, max_count: max_count, skip: offset})
        if commits.count > 0
          commits.each do |commit|
            yield commit
          end
          offset += max_count
        else
          completed = true
        end
      end
    end
  end
end
