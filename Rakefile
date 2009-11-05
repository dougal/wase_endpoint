require 'rake'
require 'spec/rake/spectask'

task :default => :spec

desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "wase_endpoint"
    gemspec.summary = "WaseEndpoint is a library for building daemons that act as WASE Endpoints for http://bit.ly/3qRMbv"
    gemspec.description = gemspec.summary
    gemspec.email = "dougal.s@gmail.com"
    gemspec.homepage = "http://github.com/dougal/wase_endpoint"
    gemspec.authors = ["Douglas F Shearer"]  
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
