require 'rubygems'

def version
  line = File.read("lib/grit_adapter/version.rb")[/^\s*VERSION\s*=\s*.*/]
  line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]
end
 
task :default => :rspec

desc "Build the gem file."
task :build do
  system "gem build grit_adapter.gemspec"
  system "mkdir -p pkg"
  system "mv gollum-grit_adapter-#{version}.gem pkg/"
end

desc 'Create a release build'
task :release => :build do
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  sh "git commit --allow-empty -a -m 'Release #{version}'"
  sh "git pull --rebase origin master"
  sh "git tag v#{version}"
  sh "git push origin master"
  sh "git push origin v#{version}"
  sh "gem push pkg/gollum-grit_adapter-#{version}.gem"
end

desc 'Publish to rubygems. Same as release'
task :publish => :release

require 'rspec/core/rake_task'

desc "Run specs."
RSpec::Core::RakeTask.new(:rspec) do |spec|
  ruby_opts = "-w"
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--backtrace --color']
end