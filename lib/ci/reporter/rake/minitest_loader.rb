$: << File.dirname(__FILE__) + "/../../.."
require 'ci/reporter/minitest'

# set defaults
MiniTest::Unit.runner = CI::Reporter::Runner.new
