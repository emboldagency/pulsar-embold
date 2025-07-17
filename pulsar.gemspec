lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pulsar/version'

Gem::Specification.new do |gem|
  gem.name           = 'pulsar-embold'
  gem.version        = Pulsar::VERSION
  gem.licenses       = ['MIT']
  gem.authors        = ['Embold']
  gem.email          = ['info@embold.com']
  gem.homepage       = 'https://github.com/emboldagency/nebulab-pulsar'
  gem.description    = 'Embold-maintained fork of Pulsar for Capistrano deployments. Originally by Matteo Latini (Nebulab).'
  gem.summary        = '
    Embold-maintained fork of Pulsar, a tool for Capistrano configuration management. The original project by Matteo Latini (Nebulab) is abandoned; this fork is actively maintained by Embold.
  '
  gem.required_ruby_version = '>= 3.0.7'
  gem.files          = `git ls-files`.split($/)
  gem.bindir         = 'exe'
  gem.executables    = gem.files.grep(%r{^exe/}).map { |f| File.basename(f) }
  gem.test_files     = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths  = ['lib']

  # gem.add_development_dependency 'bundler', '>= 2.0'
  gem.add_dependency 'dotenv', '>= 2.8.1'
  gem.add_dependency 'interactor', '> 3.0'
  gem.add_dependency 'thor', '>= 1.3.2'

  gem.add_development_dependency 'rake', '>= 13.3.0'
  gem.add_development_dependency 'rspec', '> 3.4'
  gem.add_development_dependency 'rubocop', '>= 1.78.0'
  gem.add_development_dependency 'simplecov', '> 0.21.0'
  gem.add_development_dependency 'timecop', '>= 0.9.10'
end
