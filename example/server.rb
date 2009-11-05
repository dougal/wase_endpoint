require 'rubygems'
require 'sinatra'

get '/' do
  # Pass back some json data.
  "[1,2,3]"
end

put '/' do
  # Print out the data.
  puts params.inspect
end

get '/listing' do
  "[\"@twitter_id_1\",\"@twitter_id_2\"]"
end
