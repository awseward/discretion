require 'overcommit'

module Overcommit::Hook::PreCommit
  class KeepYourDogfoodFresh < Base
    def description
      "Checking that your dogfood is fresh"
    end

    def run
      [:warn, "TODO"]
    end
  end
end
