require 'rubygems'
require 'bundler'
Bundler.require

require './fit'
map Fit.assets_prefix do
  run Fit.sprockets
end

run Fit