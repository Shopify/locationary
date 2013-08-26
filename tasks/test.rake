require 'rake/testtask'

task :default => ['test']

task :test    => ['test:unit', 'test:integration']

namespace :test do
  desc "Run integration tests"
  Rake::TestTask.new(:unit) do |t|
    t.pattern = 'tests/unit/*_test.rb'
    t.libs << 'test'
    t.verbose = true
  end

  desc "Run integration tests"
  Rake::TestTask.new(:integration) do |t|
    t.pattern = 'tests/integration/*_test.rb'
    t.libs << 'lib:test'
    t.verbose = true
  end

  desc "Run performance tests"
  Rake::TestTask.new(:performance) do |t|
    t.pattern = 'tests/performance/*_test.rb'
    t.libs << 'lib:test'
    t.verbose = true
  end
end