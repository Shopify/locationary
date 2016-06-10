# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'locationary/version'

Gem::Specification.new do |spec|
  spec.name          = "locationary"
  spec.version       = Locationary::VERSION
  spec.authors       = ["Oren Mazor"]
  spec.email         = ["oren.mazor@gmail.com"]
  spec.description   = "Gem to normalize and auto-correct location information"
  spec.summary       = "Gem to normalize and auto-correct location information"
  spec.homepage      = "https://github.com/Shopify/locationary"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "msgpack"
  spec.add_runtime_dependency "rubyzip", "~> 1.2.0"
  spec.add_runtime_dependency "snappy"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency "pry"
end
