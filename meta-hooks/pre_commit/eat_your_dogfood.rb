require 'overcommit'

module Overcommit::Hook::PreCommit
  class EatYourDogfood < Base
    def run
      [:warn, "TODO"]
    end
  end
end
