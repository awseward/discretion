require 'overcommit'

module Overcommit::Hook::PreCommit
  class EatYourDogfood < Base
    def run
      messages = [
        config['garbage'],
        Dir.pwd,
      ]

      [:warn, messages.join("\n")]
    end
  end
end
