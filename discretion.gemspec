# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'discretion/version'

Gem::Specification.new do |spec|
  spec.name          = "discretion"
  spec.version       = Discretion::VERSION
  spec.authors       = ["Andrew Seward"]
  spec.email         = ["awswrd@gmail.com"]

  spec.summary       = "A home for custom over-commit hooks"
  spec.description   = "Storage and easy installation of custom over-commit plugins"
  spec.homepage      = "https://github.com/awseward/discretion#readme"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "git", "~> 1.2"
  spec.add_runtime_dependency "overcommit", "~> 0.26"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "minitest", "~> 5.7"
  spec.add_development_dependency "pry", "~> 0"
  spec.add_development_dependency "rake", "~> 10.0"
end
