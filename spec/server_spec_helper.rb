require 'spec_helper'
require 'rack/test'
require_relative '../server.rb'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end