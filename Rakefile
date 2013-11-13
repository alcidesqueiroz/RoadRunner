#!/usr/bin/env rake
require 'rubygems'
require 'bundler/gem_tasks'

Dir.glob(File.join(File.join(File.dirname(__FILE__), 'lib/tasks/*.rake'))).each {|rt| import rt}
task :default => :register_roadrunner