require 'bundler'
Bundler::GemHelper.install_tasks

task :default => :test

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << "lib" << "test"
  test.test_files = FileList["test/unit/**/*_test.rb"]
  test.verbose = true
  # test.warning = true
end

task :console do
  sh "pry -I lib/test-subset -r test-subset.rb"
end
