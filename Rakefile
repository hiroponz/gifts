require "bundler/gem_tasks"

Bundler.setup
require 'rspec/core/rake_task'

desc "run spec"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["-c", "-fs"]
end

require 'rake/testtask'

desc "run test"
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test' << '.'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test
