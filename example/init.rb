require 'my_endpoint'

MyEndpoint.new( :username => 'twitter_username',
                :password => 'twitter_password',
                :logfile => 'my_endpoint.log',
                :sleep_period => 60 )
