require 'ci/reporter/rake/utils'

namespace :ci do
  namespace :setup do
    task :minitest do
      rm_rf ENV["CI_REPORTS"] || "test/reports"
      ENV["TESTOPTS"] = "#{ENV["TESTOPTS"]} --ci-reporter"
    end
  end
end
