#!/usr/local/rvm/rubies/ruby-1.9.3-p125/bin/ruby

# unicorn.pid
PID_PATH = "#{File.expand_path('../../tmp/pids', __FILE__)}/unicorn.pid"

# unicorn.rb
UNICORN_CONFIG_PATH = "#{File.expand_path('../../config', __FILE__)}/unicorn.rb"

system( "kill -KILL -s QUIT `cat #{PID_PATH}`" )
system( "bundle exec unicorn_rails -c #{UNICORN_CONFIG_PATH} -E production -D" )
