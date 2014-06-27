require "bundler/gem_tasks"
require 'ci/reporter/internal'
include CI::Reporter::Internal

namespace :generate do
  task :clean do
    rm_rf "acceptance/reports"
  end

  task :minitest do
    run_ruby_acceptance "acceptance/minitest_example_test.rb --ci-reporter"
  end

  task :all => [:clean, :minitest]
end

task :acceptance => "generate:all"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:acceptance_spec) do |t|
  t.pattern = FileList['acceptance/verification_spec.rb']
  t.rspec_opts = "--color"
end
task :acceptance => :acceptance_spec

task :default => :acceptance
