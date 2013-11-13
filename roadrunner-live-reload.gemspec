# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "roadrunner-live-reload"
  s.version     = RoadRunner::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alcides Queiroz Aguiar"]
  s.email       = ["alcidesqueiroz@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/roadrunner"
  s.extra_rdoc_files = ["README.md"]
  s.summary     = "A live reload command line tool written in ruby."
  s.description = s.summary
  s.extensions = ["Rakefile"]

  #s.files         = `git ls-files`.split($\)
  s.files         = [ ".gitignore", ".rspec",  
                      "Gemfile", "Gemfile.lock", 
                      "LICENSE", "README.md", "Rakefile", 
                      "lib/version.rb", "lib/websocket.rb", "src/webserver.rb", 
                      "lib/tasks/register.rake", "lib/os.rb", 
                      "roadrunner-0.3.0.debug.js", "roadrunner-live-reload.gemspec", 
                      "roadrunner.sample.yml", "spec/comingsoon.gitkeep", 
                      "src/roadrunner.rb", "distr/roadrunner", "distr/roadrunner.bat"]

  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rake", "~> 0.9.2"
end