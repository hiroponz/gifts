# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gifts/version'

Gem::Specification.new do |gem|
  gem.name          = "gifts"
  gem.version       = Gifts::VERSION
  gem.authors       = ["Sato Hiroyuki"]
  gem.email         = ["sathiroyuki@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rroonga"
  gem.add_dependency "gitlab-grit"
  gem.add_dependency "grit_ext"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry"
end
