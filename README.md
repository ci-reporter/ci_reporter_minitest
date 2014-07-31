# CI::Reporter::Minitest

Connects [Minitest][mt] to [CI::Reporter][ci], and then to your CI
system.

[![Gem Version](https://badge.fury.io/rb/ci_reporter_minitest.svg)](http://badge.fury.io/rb/ci_reporter_minitest)
[![Build Status](https://travis-ci.org/ci-reporter/ci_reporter_minitest.svg?branch=master)](https://travis-ci.org/ci-reporter/ci_reporter_minitest)
[![Dependency Status](https://gemnasium.com/ci-reporter/ci_reporter_minitest.svg)](https://gemnasium.com/ci-reporter/ci_reporter_minitest)
[![Code Climate](https://codeclimate.com/github/ci-reporter/ci_reporter_minitest.png)](https://codeclimate.com/github/ci-reporter/ci_reporter_minitest)

[mt]: https://github.com/seattlerb/minitest
[ci]: https://github.com/ci-reporter/ci_reporter

## Supported versions

The latest release of Minitest 5.x is supported.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ci_reporter_minitest'
```

And then install it:

```
$ bundle
```

## Usage

Require the reporter in your Rakefile, and ensure that
`ci:setup:minitest` is a dependency of your minitest task:

```ruby
require 'ci/reporter/rake/minitest'

# ...
# Rake code that creates a task called `:minitest`
# ...

task :test => 'ci:setup:minitest'
```

### Advanced usage

Refer to the shared [documentation][ci] for details on setting up
CI::Reporter.

## Contributing

1. Fork it ( https://github.com/ci-reporter/ci_reporter_minitest/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add a failing test.
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Ensure tests pass.
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new Pull Request
