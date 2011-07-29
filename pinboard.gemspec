Gem::Specification.new do |s|
  s.add_development_dependency 'yard', '~> 0.7'
  s.add_development_dependency 'rake', '~> 0.9'
  s.add_development_dependency 'rspec', '~> 2.6'
  s.add_development_dependency 'ZenTest', '~> 4.5'
  s.add_development_dependency 'webmock', '~> 1.6'
  s.add_runtime_dependency 'httparty', '~> 0.7'
  s.name = 'pinboard'
  s.version = '0.0.0'
  s.date = '2011-07-28'
  s.summary = "Ruby wrapper for the Pinboard API"
  s.description = "Ruby wrapper for the Pinboard API"
  s.authors = ["Ry Waker"]
  s.email = 'ry@rywalker.com'
  s.require_paths = ['lib']
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.homepage = 'http://github.com/ryw/pinboard'
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
end
