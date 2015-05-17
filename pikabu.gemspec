# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pikabu/version'

Gem::Specification.new do |spec|
  spec.name          = "pikabu"
  spec.version       = Pikabu::VERSION
  spec.authors       = ["Dana Najjar, Waruna Perera"]
  spec.email         = ["najjar.dana@gmail.com, wperera6@gmail.com"]

  spec.summary       = %q{Pikabu is a gem that finds your errors for you.}
  spec.homepage      = "https://github.com/dnajjar/pikabu"
  spec.license       = "MIT License"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables << 'pikabu'
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
    
end
