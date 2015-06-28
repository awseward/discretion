require 'overcommit'

module Overcommit::Hook::PreCommit
  class KeepYourDogfoodFresh < Base
    def run
      [:warn, "TODO"]
    end
  end
end
