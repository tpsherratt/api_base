ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)

require 'rspec/rails'
require 'shoulda-matchers'
require 'factory_girl_rails'
require 'database_cleaner'

Dir[ApiBase::Engine.root.join("spec/support/**/*.rb")].each {|f| require f}


# Grab FactoryGirl factory definitions from other engines
#
# FactoryGirl.definition_file_paths << MyEngine::Engine.root.join("spec/factories")
# FactoryGirl.definition_file_paths << MyOtherEngine::Engine.root.join("spec/factories")
# FactoryGirl.find_definitions


RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"


  # Reset database before sweet/around each example
  # setup database cleaning
  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end
  # execute databse cleaning
  config.around :each do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
