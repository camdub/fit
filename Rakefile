require 'rubygems'
require 'bundler'
require './fitbit_updater'
Bundler.require

desc 'Update data from Fitbit'
task :update do
  FitbitUpdater.update
  puts "Done at #{Time.now.strftime('%I:%M%p').downcase}"
end

