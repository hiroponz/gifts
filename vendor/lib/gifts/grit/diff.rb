    attr_reader :binary_file
    def initialize(repo, a_path, b_path, a_blob, b_blob, a_mode, b_mode, new_file, deleted_file, diff, renamed_file = false, similarity_index = 0, binary_file = false)
      @binary_file      = binary_file
    def self.list_from_string(repo, text, a)
        binary_file = false
          3.times { lines.shift } # shift away the similarity line and the 2 `rename from/to ...` lines
        if sim_index == 100
          ls_tree = repo.git.native(:ls_tree, {}, a, a_path)
          m = ls_tree.match(/^(\d+) blob ([0-9A-Fa-f]+)/)
          a_mode = b_mode = m[0]
          a_blob = b_blob = m[1]
          diff = nil
        else
          m, a_blob, b_blob, b_mode = *lines.shift.match(%r{^index ([0-9A-Fa-f]+)\.\.([0-9A-Fa-f]+) ?(.+)?$})
          b_mode.strip! if b_mode
          diff_lines = []
          while lines.first && lines.first !~ /^diff/
            line = lines.shift
            diff_lines << line if line !~ /^(-{3}|\+{3})/
          end

          if diff =~ /\ABinary/
            binary_file = true
            diff = nil
          else
            diff = diff_lines.join("\n")
          end
        diffs << Diff.new(repo, a_path, b_path, a_blob, b_blob, a_mode, b_mode, new_file, deleted_file, diff, renamed_file, sim_index, binary_file)