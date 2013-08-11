require 'rubygems'
require 'json'
require 'bundler'
Bundler.require

class FitbitUpdater

  @@today = Date.today

  class << self

    def update
      @client ||= fitbit_client
      @redis ||= redis

      @redis['distance'] = JSON.dump(@client.data_by_time_range('/activities/log/distance', base_date: @@today.to_s, period: '1w')['activities-log-distance'])
      @redis['caloriesIn'] = JSON.dump(@client.data_by_time_range('/foods/log/caloriesIn', base_date: @@today.to_s, period: '1w')['foods-log-caloriesIn'])
      @redis['sleep'] = @client.data_by_time_range('/sleep/minutesAsleep', base_date: @@today.to_s, period: '1d')['sleep-minutesAsleep'][0]['value'].to_i
      @redis['leaderboard'] = JSON.dump(@client.weekly_leaderboard)
      @redis['last_updated'] = Time.now.utc
    end

    def redis
      uri = URI.parse(ENV['REDIS_URI'])
      Redis.new(host: uri.host, port: uri.port, password: uri.password)
    end

    private

    def fitbit_client
      Fitgem::Client.new({
        consumer_key: ENV['CONSUMER_KEY'],
        consumer_secret: ENV['CONSUMER_SECRET'],
        token: ENV['TOKEN'],
        secret: ENV['SECRET']
      })
    end

  end

end
