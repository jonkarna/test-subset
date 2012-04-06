$:.push File.expand_path("../lib", __FILE__)
require 'test-subset/version'

Gem::Specification.new do |s|
  s.name        = "test-subset"
  s.version     = TestSubset::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jon Karna"]
  s.email       = ["ipg49vv2@gmail.com"]
  s.homepage    = "https://github.com/jonkarna/test-subset"
  s.summary     = %q{}
  s.description = %q{}

  s.rubyforge_project = "test-subset"

  s.add_runtime_dependency "rake"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
