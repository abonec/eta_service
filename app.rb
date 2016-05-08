$:.unshift File.dirname(__FILE__)

Bundler.require
require 'app/api'
require 'app/models/cab'


module App
  def env
    ENV['ENV'] || 'development'
  end
  module_function :env
  Config.load_and_set_settings(Config.setting_files(File.join(File.dirname(__FILE__), 'config'), env))
end