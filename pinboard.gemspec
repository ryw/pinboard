Gem::Specification.new do |s|
  s.add_development_dependency 'yard'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'

  s.name = 'pinboard'
  s.version = '2026.2.0'
  s.summary = "Ruby wrapper for the Pinboard API"
  s.description = "Ruby wrapper for the Pinboard API"
  s.authors = ["Ry Waker", "Jan-Erik Rediger", "Nicholas E. Rabenau"]
  s.email = 'ry@rywalker.com'
  s.require_paths = ['lib']
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/ryw/pinboard'
  s.required_ruby_version = '>= 3.0'
end
