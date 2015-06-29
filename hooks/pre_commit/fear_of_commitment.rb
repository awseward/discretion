require 'overcommit'

module Overcommit::Hook::PreCommit
  class FearOfCommitment < Base
    def description
      "Checking commit size"
    end

    def run
      checks = [
        :too_many_files,
        :too_many_lines
      ]

      if checks.any?{|c| send c }
        messages = [
          "Modified by this commit:",
          "  Files: #{total_modified_files}",
          "  Lines: #{total_modified_lines}",
          "Prefer making smaller, more frequent commits",
        ]

        [:warn, messages.join("\n")]
      else
        :pass
      end
    end

    private

    def max_files_modified
      config['max_files_modified'] || 20
    end

    def max_lines_modified
      config['max_lines_modified'] || 200
    end

    def too_many_files
      total_modified_files > max_files_modified
    end

    def too_many_lines
      total_modified_lines > max_lines_modified
    end

    def total_modified_files
      @context.modified_files.count
    end

    def total_modified_lines
      @context.modified_files.map do |file|
        modified_lines_in_file(file).size
      end.reduce(:+)
    end
  end
end
