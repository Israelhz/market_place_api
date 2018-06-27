RSpec.configure do |config|
  config.include Warden::Test::Helpers

  # Controller tests are on their way out...
  config.include Devise::Test::ControllerHelpers, type: :controller
end
