# ProfileAction

This gem profiles actions with [ruby-prof](https://github.com/ruby-prof/ruby-prof) and logs
results to a specified log (intended for Rails log). It prints results with the RubyProf::FlatPrinter which is
succinct. Results can be printed in JSON so it can be consumed by a log manager like Splunk, etc.

Motivation: profiling can be turned on/off on a troublesome action in production by setting
an environment variable. Results are logged to the Rails logger (if configured)
so no extra steps are required to pipe it into your log manager.

**This is a WIP.**

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'profile_action', git: 'https://github.com/ed-mare/profile_action.git'
```

And then execute:
```bash
$ bundle
```

## Usage

```ruby
# 1) Configure the gem. In config/initializers/profile_action.rb
ProfileAction.configure do |c|
   # reduces the output to methods where %self is this percentage.
   c.min_percent = 2

   # Set to your rails logger. Defaults to  Logger.new(STDOUT).
   c.logger = Rails.logger

   # By default it prints text. Set to true to log json.
   c.print_json = true

   # By default log level is :info.
   c.log_level = :debug

   # By default json is on one line. Set to true to pretty print json.
   c.pretty_json = true

   # Can turn on based on environment variable.
   c.profile = ENV["PROFILE"] == '1'
 end

 # 2) Include in controller and create an around filter/action.
 class ItemsController < Api::BaseController
   include ProfileAction::Profile
   around_action :profile, only: :index
 end
```

Text output looks like this. This is with  min_percent = 2.

```shell
App 484 stdout: Class: ItemsController, Method: index
App 484 stdout: Measure Mode: wall_time
App 484 stdout: Thread ID: 13692520
App 484 stdout: Fiber ID: 25920660
App 484 stdout: Total: 0.036531
App 484 stdout: Sort by: self_time
App 484 stdout:
App 484 stdout:  %self      total      self      wait     child     calls  name
App 484 stdout:   4.25      0.002     0.002     0.000     0.000        3   PG::Connection#async_exec
App 484 stdout:   2.18      0.018     0.001     0.000     0.017      322  *Class#new
App 484 stdout:
App 484 stdout: * indicates recursively called methods
```

Json output looks like this:

```json
[{"header":{"Measure Mode":"wall_time","Thread ID":"9299240","Total":"0.115787","Sort by":"self_time","Fiber ID":"30538500"}},{"methods":[{"%self":"7.74","total":"0.009","self":"0.009","wait":"0.000","children_time":"0.000","calls":"5","cycle":" ","name":"PG::Connection#async_exec"},{"%self":"4.94","total":"0.013","self":"0.006","wait":"0.000","children_time":"0.007","calls":"11","cycle":"*","name":"Kernel#require"},{"%self":"4.36","total":"0.006","self":"0.005","wait":"0.000","children_time":"0.001","calls":"149","cycle":" ","name":"Module#module_eval"},{"%self":"2.68","total":"0.003","self":"0.003","wait":"0.000","children_time":"0.000","calls":"558","cycle":" ","name":"Regexp#match"}]},{"profiled":{"class":"Api::V1::ItemsController","method":"index"}}]
```

## Development

1) Build the docker image:

```shell
docker-compose build
```

2) Start docker image with an interactive bash shell:

```shell
docker-compose run --rm gem
```

3) Once in bash session, code, run tests, start console, etc.

```shell
# run console with gem loaded
bundle console

# run tests
rspec
```

## Todo

- Finish tests.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
