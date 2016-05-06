$:.unshift File.dirname(__FILE__)

Bundler.require
require 'app/api'
require 'app/models/cab'

module App
end