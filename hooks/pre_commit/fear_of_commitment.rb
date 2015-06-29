require 'overcommit'

module Overcommit::Hook::PreCommit
  class FearOfCommitment < Base
    def description
      "Checking commit size"
    end

    def run
      [:warn, "TODO"]
    end
  end
end
