# encoding: utf-8

set :config_dir, settings.root + '/config'
set :views, settings.root + '/app/views'
require 'json'
require 'rack-flash'
require 'padrino-helpers'
require settings.root + '/app/init'
