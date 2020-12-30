Gem::Specification.new do |s|
  s.add_development_dependency 'yard'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-bundler'
  s.add_development_dependency 'libnotify'
  s.add_development_dependency 'rb-inotify'
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'terminal-notifier-guard'

  s.add_runtime_dependency 'httparty'
  s.name = 'pinboard'
  s.version = '1.1.0'
  s.date = '2020-12-30'
  s.summary = "Ruby wrapper for the Pinboard API"
  s.description = "Ruby wrapper for the Pinboard API"
  s.authors = ["Ry Waker", "Jan-Erik Rediger", "Nicholas E. Rabenau"]
  s.email = 'ry@rywalker.com'
  s.require_paths = ['lib']
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.homepage = 'http://github.com/ryw/pinboard'
end
