require 'sinatra/base'
require 'sprockets'
require 'sprockets-helpers'

class Fit < Sinatra::Base

  set :sprockets, Sprockets::Environment.new(root)
  set :assets_prefix, '/assets'

  configure do
    sprockets.append_path File.join(root, 'assets', 'css')
    sprockets.append_path File.join(root, 'assets', 'js')
    # sprockets.append_path File.join(root, 'assets', 'images')

    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix      = assets_prefix
      # config.digest      = digest_assets
      # config.public_path = public_folder

      # Debug mode automatically sets
      # expand = true, digest = false, manifest = false
      config.debug       = true if development?
    end
  end

  helpers do
    include Sprockets::Helpers
  end

  get '/' do
    erb :index
  end

end