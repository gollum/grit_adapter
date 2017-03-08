# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "grit_adapter/version"

Gem::Specification.new do |s|
  s.name        = "gollum-grit_adapter"
  s.version     = Gollum::Lib::Git::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bart Kamphorst, Dawa Ometto"]
  s.email       = ["repotag-dev@googlegroups.com"]
  s.homepage    = "https://github.com/gollum/grit_adapter"
  s.summary     = %q{Adapter for Gollum to use Grit at the backend.}
  s.description = %q{Adapter for Gollum to use Grit at the backend.}
  s.license	= "MIT"

  s.add_runtime_dependency 'gitlab-grit', '>= 2.7.1'
  s.add_development_dependency "rspec", "3.4.0"

  s.files         = Dir['lib/**/*.rb'] + ["README.md", "Gemfile"]
  s.require_paths = ["lib"]
end

