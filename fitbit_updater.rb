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
      uri = URI.parse('redis://redistogo:5f2371feb9c56a3fcd1ae6a6fb6406cd@crestfish.redistogo.com:9025')
      Redis.new(host: uri.host, port: uri.port, password: uri.password)
    end

    private

    def fitbit_client
      Fitgem::Client.new({
        consumer_key: '2675ab1c5fd24cf593de8cbdeb24b084',
        consumer_secret: 'dc2438c31a4f43348c5e1ca11921006d',
        token: 'b89ec6979afdb5ab6a75914d474517b1',
        secret: 'f8d51496432df15e7b8f2019e98b4ae9'
      })
    end

  end

end
