# frozen_string_literal: true

require 'rspec'
require 'tmpdir'
require_relative 'allure_helper'
require_relative 'driver_helper'
require 'sparkling_watir'

module SpecHelper

  AllureHelper.configure
  RSpec.configure do |config|
    config.formatter = AllureHelper.formatter
    config.include(DriverHelper)
    config.before(:each) do
      app
    end

    config.after(:each) do |example|
      example_name = example.description
      Dir.mktmpdir do |temp_folder|
        screenshot = app.screenshot.save("#{temp_folder}/#{example_name}.png")
        AllureHelper.add_screenshot(example_name, screenshot)
      end
      app.close
    end
  end
end
