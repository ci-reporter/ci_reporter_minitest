module Minitest
  def self.plugin_ci_reporter_options(opts, options)
    opts.on "--ci-reporter", "Output to CI::Reporter" do
      options[:ci_reporter] = true
    end
  end

  def self.plugin_ci_reporter_init(options)
    if options[:ci_reporter]
      require 'ci/reporter/minitest'
      self.reporter << CI::Reporter::Runner.new
    end
  end
end
