$:.unshift File.dirname(__FILE__)

Bundler.require
require 'app/api'
require 'app/models/cab'

APP_ENV = 'development'
module App
  Config.load_and_set_settings(Config.setting_files(File.join(File.dirname(__FILE__), 'config'), APP_ENV))
end