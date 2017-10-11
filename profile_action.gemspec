lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'profile_action/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'profile_action'
  s.version     = ProfileAction::VERSION
  s.authors     = ['ed.mare']
  s.homepage    = 'https://github.com/ed-mare/json_api_server'
  s.summary     = 'Profile Rails actions with an around ruby-prof filter.' \
      ' Prints FlatPrinter to log as text or optionally JSON.'
  s.description = 'Profile Rails actions with an around ruby-prof filter.'  \
      ' Prints FlatPrinter to log as text or optionally JSON.'
  s.license     = 'MIT'

  if s.respond_to?(:metadata)
    s.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  s.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.required_ruby_version = '>= 2.1'

  s.add_dependency 'ruby-prof', '~> 0.16'

  s.add_development_dependency 'bundler', '>= 1.13'
  s.add_development_dependency 'rake', '>= 10.0'
  s.add_development_dependency 'rspec', '>= 3.0'
  s.add_development_dependency 'rubocop', '>= 0.47'
end
