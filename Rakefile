#!/usr/bin/env rake
require 'rubygems'

found_gspec = Gem::Dependency.new('bundler').matching_specs.sort_by(&:version).last
unless found_gspec
  puts "******Bundler not found; Install Bundler by running: sudo gem install bundler*******"
end

require 'bundler/gem_tasks'

Dir.glob(File.join(File.join(File.dirname(__FILE__), 'lib/tasks/*.rake'))).each {|rt| import rt}
task :default => :register_roadrunner