$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "api_base/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "api_base"
  s.version     = ApiBase::VERSION
  s.authors     = ["Piers Rollinson", "Tim Sherratt"]
  s.email       = ["piers@mitoo.co", "tim@mitoo.co"]
  s.summary     = "ApiBase Gem"
  s.description = "ApiBase Gem"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]


  # Gem dependencies 
  s.add_dependency "rails", "~> 4.1.6"
  s.add_dependency "storm"
  s.add_dependency "pundit"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "database_cleaner"
  # for running specs within the dummy app
  s.add_development_dependency "mysql2"

  # Add Development Dependenies here
end
