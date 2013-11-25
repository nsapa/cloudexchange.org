require 'rubygems'
require 'sinatra'
require 'erb'

set :environment, ENV['RACK_ENV'].to_sym
disable :run, :reload

require './app.rb'

run Sinatra::Application
