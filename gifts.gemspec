# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
vendor = File.expand_path('../vendor/lib', __FILE__)
$LOAD_PATH.unshift(vendor) unless $LOAD_PATH.include?(vendor)
require 'gifts/version'

Gem::Specification.new do |gem|
  gem.name          = "gifts"
  gem.version       = Gifts::VERSION
  gem.authors       = ["Sato Hiroyuki"]
  gem.email         = ["sathiroyuki@gmail.com"]
  gem.description   = %q{Git Fulltext Search library}
  gem.summary       = %q{Git Fulltext Search library}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib", "vendor/lib"]

  gem.add_dependency "posix-spawn", "~> 0.3.6"
  gem.add_dependency "mime-types", "~> 1.15"
  gem.add_dependency "diff-lcs", "~> 1.1"
  gem.add_dependency "charlock_holmes", "~> 0.6.9"
  gem.add_dependency "rroonga", "~> 2.1.3"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "mocha"
end
