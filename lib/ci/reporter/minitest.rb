require 'ci/reporter/core'
require 'minitest'

module CI
  module Reporter
    class Failure
      def self.classify(fault)
        if fault.class == ::Minitest::Assertion
          MiniTestFailure.new(fault)
        else
          MiniTestError.new(fault)
        end
      end

      def initialize(fault) @fault = fault end
      def name() @fault.error.class.name end
      def message() @fault.message end
      def location() @fault.location end
    end

    class MiniTestFailure < Failure
      def failure?() true end
      def error?() false end
    end

    class MiniTestError < Failure
      def failure?() false end
      def error?() true end
    end

    class ActualCapture
      def start
        @capture_out = OutputCapture.wrap($stdout) {|io| $stdout = io }
        @capture_err = OutputCapture.wrap($stderr) {|io| $stderr = io }
      end

      def finish
        [@capture_out.finish, @capture_err.finish]
      end
    end

    class NoCapture
      def start
      end

      def finish
        [nil, nil]
      end
    end

    class Runner < ::Minitest::AbstractReporter
      def initialize
        @report_manager = ReportManager.new("test")

        # We have to handle this ourselves
        if ENV['CI_CAPTURE'] == "off"
          @capturer = NoCapture.new
        else
          @capturer = ActualCapture.new
        end
        ENV['CI_CAPTURE'] = "off"
      end

      def start
        # We start to capture the std{out,err} here so that it is
        # available at the end of the first test run.
        @capturer.start
      end

      def record(result)
        # Get the std{out,err} of the now-finished test before
        # changing suites so that its lifecycle matches `result`.
        stdout, stderr = @capturer.finish
        @capturer.start

        # This is the only method that gets to know what test and
        # suite we are in, and is only called at the granularity of a
        # test. We have to work backwards to understand when the suite
        # changes.
        if @current_suite_class != result.class
          finish_suite
          start_suite
        end

        @current_suite_class = result.class
        @current_suite.name = result.class.to_s

        tc = TestCase.new(result.name, result.time, result.assertions)
        tc.failures = result.failures.map {|f| Failure.classify(f)}
        tc.skipped = result.skipped?

        @current_suite.testcases << tc
        @current_suite.assertions += tc.assertions
        @current_suite_stdout << stdout
        @current_suite_stderr << stderr
      end

      def report
        finish_suite
      end

      private

      def start_suite
        @current_suite = TestSuite.new("placeholder suite name")
        @current_suite.start

        @current_suite.assertions = 0
        @current_suite_stdout = []
        @current_suite_stderr = []
      end

      def finish_suite
        return unless @current_suite

        @current_suite.finish
        @current_suite.stdout = @current_suite_stdout.join
        @current_suite.stderr = @current_suite_stderr.join

        @report_manager.write_report(@current_suite)
      end
    end
  end
end
