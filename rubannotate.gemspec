# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubannotate/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubannotate'
  spec.version       = Rubannotate::VERSION
  spec.authors       = ['John Doe']
  spec.email         = ['johndoe@example.com']

  spec.summary       = 'Annotate Rails classes with schema.'
  spec.description   = 'Annotate Rails classes with schema.'
  spec.homepage      = 'https://github.com/souk4711/rubannotate'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set
  # the 'allowed_push_host', to allow pushing to a single host or delete
  # this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/souk4711/rubannotate'
    spec.metadata['changelog_uri'] = 'https://github.com/souk4711/rubannotate'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been
  # added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 5.1'

  spec.add_development_dependency 'appraisal', '~> 2.2'
  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.74'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.35'

  spec.add_development_dependency 'pg', '~> 1.1'
  spec.add_development_dependency 'rails', '~> 5.1'
  spec.add_development_dependency 'sqlite3', '~> 1.4'
end
