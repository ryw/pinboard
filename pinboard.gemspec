Gem::Specification.new do |s|
  s.add_development_dependency 'yard', '~> 0.7'
  s.add_development_dependency 'rake', '~> 0.9'
  s.add_development_dependency 'rspec', '~> 2.6'
  s.add_development_dependency 'webmock', '~> 1.6'
  s.add_development_dependency 'guard-rspec', '~> 0.5'
  s.add_development_dependency 'guard-bundler'
  s.add_development_dependency 'libnotify'
  s.add_development_dependency 'rb-inotify'
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'terminal-notifier-guard'

  s.add_runtime_dependency 'httparty', '= 0.7.8'
  s.name = 'pinboard'
  s.version = '0.0.4'
  s.date = '2012-05-08'
  s.summary = "Ruby wrapper for the Pinboard API"
  s.description = "Ruby wrapper for the Pinboard API"
  s.authors = ["Ryan Waker"]
  s.email = 'ry@anotherventure.com'
  s.require_paths = ['lib']
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.homepage = 'http://github.com/ryw/pinboard'
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
end
