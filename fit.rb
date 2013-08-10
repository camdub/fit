require './fitbit_updater'

Sinatra::register Gon::Sinatra

class Fit < Sinatra::Application

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
    redis = FitbitUpdater.redis
    gon.distance = redis['distance']
    gon.last_updated = redis['last_updated']
    gon.caloriesIn = redis['caloriesIn']

    @beating_zack = JSON(redis['leaderboard'])['friends'].first['rank']['steps'] != 1
    @margin_zack = get_step_margin(JSON(redis['leaderboard']))
    haml :index
  end

  private 

  def get_step_margin(leaderboard)
    zack = leaderboard['friends'].first
    me = leaderboard['friends'][1]

    me['summary']['steps'] - zack['summary']['steps']
  end

end