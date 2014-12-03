Gem::Specification.new do |spec|
  spec.name          = 'rui'
  spec.version       = '0.1.0'
  spec.authors       = ['Luke Morton']
  spec.email         = ['lukemorton.dev@gmail.com']
  spec.summary       = %q{Ruby user interface library for HTML/CSS}
  spec.homepage      = 'https://github.com/DrPheltRight/rui'
  spec.license       = 'MIT'

  spec.files         = Dir['{lib,spec}/**/*.rb'] + ['README.md']
  spec.test_files    = ['spec']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
