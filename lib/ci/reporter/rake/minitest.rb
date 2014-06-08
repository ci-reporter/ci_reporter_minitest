require 'ci/reporter/rake/utils'

namespace :ci do
  namespace :setup do
    task :minitest do
      rm_rf ENV["CI_REPORTS"] || "test/reports"
      test_loader = CI::Reporter.maybe_quote_filename "#{File.dirname(__FILE__)}/minitest_loader.rb"
      ENV["TESTOPTS"] = "#{ENV["TESTOPTS"]} #{test_loader}"
    end
  end
end
