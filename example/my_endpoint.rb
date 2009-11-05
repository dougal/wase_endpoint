require 'rubygems'
require 'wase_endpoint'

class MyEndpoint < WaseEndpoint
  
  # Just return our json as it came in.
  def secret_sauce(raw_json)
    raw_json
  end
  
end
