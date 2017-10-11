$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'profile_action/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'profile_action'
  s.version     = ProfileAction::VERSION
  s.authors     = ['ed.mare']
  s.homepage    = 'https://github.com/ed-mare/json_api_server'
  s.summary     = 'Profile Rails actions with an around ruby-prof filter.'
  s.description = 'Profile Rails actions with an around ruby-prof filter.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.0'
  s.add_dependency 'ruby-prof', '~> 0.16'
  s.add_dependency 'ruby_prof-json', '~> 0.0'

  # TODO: - remove test app or just database dependency?
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rubocop', '>= 0.47'
end
