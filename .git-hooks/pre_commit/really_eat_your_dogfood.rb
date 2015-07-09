require 'overcommit'

module Overcommit::Hook::PreCommit
  class ReallyEatYourDogfood < Base
    def description
      "Checking for unused plugins"
    end

    def run
      [:warn, "TODO"]
    end
  end
end
